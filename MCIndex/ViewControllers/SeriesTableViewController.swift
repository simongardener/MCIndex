//
//  SeriesTableViewController.swift
//  MCIndex
//
//  Created by Simon Gardener on 30/11/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import UIKit
import CoreData

class SeriesTableViewController: UITableViewController {

    var container : NSPersistentContainer!
    var filtered = [NSFetchedResultsSectionInfo]()
    var searchController = UISearchController(searchResultsController: nil)
    let initialSearchBarOffset = 56.0
    let cancelSearchBarOffset = -8.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading series view")
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
        searchController.searchBar.placeholder = "Search by Series"
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
        filtered = frc.sections!.filter { $0.name.lowercased().contains(searchText.lowercased())}
        tableView.reloadData()
    }
    fileprivate func hideSearchBar(yAxisOffset : Double){
        self.tableView.contentOffset = CGPoint(x:0.0, y:yAxisOffset)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering() {
            return filtered.count
        }
        return frc.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    
    fileprivate lazy var frc : NSFetchedResultsController<Story> = {
        let storyFetch : NSFetchRequest<Story> = Story.fetchRequest()
        let sortBySeries = NSSortDescriptor(key: #keyPath(Story.seriesName), ascending: true)
        let sortByVolume = NSSortDescriptor(key: #keyPath(Story.inVolume), ascending: true )
        let sortByOrder = NSSortDescriptor(key: #keyPath(Story.order), ascending: true)
        storyFetch.sortDescriptors = [sortBySeries,sortByVolume,sortByOrder]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: storyFetch, managedObjectContext: container.viewContext, sectionNameKeyPath: #keyPath(Story.seriesName), cacheName: nil)
        return fetchedResultsController
    }()
    fileprivate func fetchStories(){
        do{
            try frc.performFetch()
        }catch{
            print("Unable to fetch stories")
            print("\(error), \(error.localizedDescription)")

        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeriesCell", for: indexPath)
        guard let sections = frc.sections else {fatalError("no sections in FRC")}
        if isFiltering(){
            cell.textLabel?.text = filtered[indexPath.section].name 
        } else {
            let secInfo = sections[indexPath.section]
            cell.textLabel?.text = secInfo.name
        }
        return cell
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let storiesVC = segue.destination as! StoriesTableViewController
        
        let indexPath = tableView.indexPathForSelectedRow!
        if isFiltering() {
            let stories = filtered[indexPath.section].objects as! [Story]
            let name = filtered[indexPath.section].name
            storiesVC.title = name
            storiesVC.inject(stories)
        }else {
            let stories = frc.sections?[indexPath.section].objects as! [Story]
            let name = frc.sections?[indexPath.section].name
            storiesVC.title = name
            storiesVC.inject(stories)
        }
    }

}

extension SeriesTableViewController : NeedsContainer{
    func assertDependencies() {
        assert(container != nil, "Didnt get a container passed in.")
    }
}
extension SeriesTableViewController : UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        hideSearchBar(yAxisOffset: cancelSearchBarOffset)
    }
}

extension SeriesTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("delegate got the message")
        
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
