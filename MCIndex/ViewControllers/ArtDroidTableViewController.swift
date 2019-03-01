//
//  ArtDroidTableViewController.swift
//  MCIndex
//
//  Created by Simon Gardener on 22/02/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import UIKit
import CoreData

class ArtDroidTableViewController: SearchingTableViewController{

    var container : NSPersistentContainer!
    var filtered = [Artist]()

    let cellId = "ArtDroidCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        fetchStories()
        setupSearchController()
    }

   override func setupSearchController() {
        super.setupSearchController()
       searchController.searchBar.placeholder = "Search by Artist"
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
    
    fileprivate lazy var frc : NSFetchedResultsController<Artist> = {
        let artistFetch : NSFetchRequest<Artist> = Artist.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Artist.fullName), ascending: true)
        artistFetch.sortDescriptors = [sortByName]
        let predicate = NSPredicate(format: "stories.@count > %d", 0)
        artistFetch.predicate = predicate
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: artistFetch, managedObjectContext: container.viewContext, sectionNameKeyPath:nil, cacheName: nil)
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
        
        let vc =  segue.destination as! StoriesByArtistTableViewController
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

extension ArtDroidTableViewController   : NeedsContainer{
    func assertDependencies() {
        assert(container != nil, "Didnt get a container passed in.")
    }
}
