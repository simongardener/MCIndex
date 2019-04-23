//
//  WriterTableViewController.swift
//  MCIndex
//
//  Created by Simon Gardener on 22/02/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import UIKit
import CoreData

class ScriptDroidTableViewController:SearchingTableViewController {
    
    var container : NSPersistentContainer!
    var filtered = [Writer]()
    let cellId = "ScriptDroidCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        fetchStories()
        setupSearchController()
    }
    
    override func setupSearchController() {
        super.setupSearchController()
        searchController.searchBar.placeholder = "filter writer names"
    }
    
    override func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filtered = (frc.fetchedObjects?.filter { $0.fullName!.lowercased().contains(searchText.lowercased())})!
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filtered.count
        } else {
            return frc.fetchedObjects?.count ?? 0
        }
    }
    
    fileprivate lazy var frc : NSFetchedResultsController<Writer> = {
        let writerFetch : NSFetchRequest<Writer> = Writer.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Writer.fullName), ascending: true)
        writerFetch.sortDescriptors = [sortByName]
        let predicate = NSPredicate(format: "stories.@count > %d", 0)
        writerFetch.predicate = predicate
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: writerFetch, managedObjectContext: container.viewContext, sectionNameKeyPath:nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    fileprivate func fetchStories(){
        do{
            try frc.performFetch()
        }catch{
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
        
        let vc =  segue.destination as! StoriesByWriterTableViewController
        let indexPath = tableView.indexPathForSelectedRow!
        var name : String
        if isFiltering() {
            name = filtered[indexPath.row].fullName!
        }else {
            name = frc.fetchedObjects![indexPath.row].fullName!
        }
        vc.droidName = name
        vc.container = container
    }
}

extension ScriptDroidTableViewController : NeedsContainer{
    func assertDependencies() {
        assert(container != nil, "Didnt get a container passed in.")
    }
}
