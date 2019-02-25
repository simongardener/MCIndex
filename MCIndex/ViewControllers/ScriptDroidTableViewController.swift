//
//  WriterTableViewController.swift
//  MCIndex
//
//  Created by Simon Gardener on 22/02/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import UIKit
import CoreData
class ScriptDroidTableViewController: UITableViewController {
    
    var container : NSPersistentContainer!
    var filtered = [Writer]()
    var searchController = UISearchController(searchResultsController: nil)
    let initialSearchBarOffset = 56.0
    let cancelSearchBarOffset = -8.0
    
    let cellId = "ScriptDroidCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading script Droid view")
        assertDependencies()
        fetchStories()
        setupSearchController()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupSearchController() {
        hideSearchBar(yAxisOffset: initialSearchBarOffset)
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.barTintColor = UIColor(white: 0.9, alpha: 0.9)
        searchController.searchBar.placeholder = "Search by writer"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.delegate = self
        tableView.tableHeaderView = searchController.searchBar
    }
    //filtering methods
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filtered = (frc.fetchedObjects?.filter { $0.fullName!.lowercased().contains(searchText.lowercased())})!
        tableView.reloadData()
    }
    fileprivate func hideSearchBar(yAxisOffset : Double){
        self.tableView.contentOffset = CGPoint(x:0.0, y:yAxisOffset)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc.fetchedObjects?.count ?? 0
    }
    
    
    fileprivate lazy var frc : NSFetchedResultsController<Writer> = {
        let writerFetch : NSFetchRequest<Writer> = Writer.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Writer.fullName), ascending: true)
        writerFetch.sortDescriptors = [sortByName]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: writerFetch, managedObjectContext: container.viewContext, sectionNameKeyPath:nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    fileprivate func fetchStories(){
        do{
            try frc.performFetch()
        }catch{
            print("Unable to fetch artist")
            print("\(error), \(error.localizedDescription)")
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if isFiltering(){
            cell.textLabel?.text = filtered[indexPath.row].fullName
        } else {
            cell.textLabel?.text = frc.fetchedObjects?[indexPath.row].fullName ?? "Unknown"
        }
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //        let storiesVC = segue.destination as! StoriesTableViewController
        //
        //        let indexPath = tableView.indexPathForSelectedRow!
        //        if isFiltering() {
        //            let stories = filtered[indexPath.section].objects as! [Story]
        //            let name = filtered[indexPath.section].name
        //            storiesVC.title = name
        //            storiesVC.inject(stories)
        //        }else {
        //            let stories = frc.sections?[indexPath.section].objects as! [Story]
        //            let name = frc.sections?[indexPath.section].name
        //            storiesVC.title = name
        //            storiesVC.inject(stories)
        //        }
    }
    
}

extension ScriptDroidTableViewController : UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        hideSearchBar(yAxisOffset: cancelSearchBarOffset)
    }
}

extension ScriptDroidTableViewController  : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("delegate got the message")
        
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
extension ScriptDroidTableViewController : NeedsContainer{
    func assertDependencies() {
        assert(container != nil, "Didnt get a container passed in.")
    }
}
