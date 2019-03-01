//
//  VolumesTableViewController.swift
//  MCIndex
//
//  Created by Simon Gardener on 30/11/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import UIKit
import CoreData

class VolumesTableViewController: SearchingTableViewController {
    
    var container: NSPersistentContainer!
    var filtered = [Volume]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        fetchVolumes()
        setupSearchController()
    }
    
    override func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filtered = (frc.fetchedObjects?.filter { $0.title!.lowercased().contains(searchText.lowercased())})!
        tableView.reloadData()
    }
    override func setupSearchController() {
        super.setupSearchController()
         searchController.searchBar.placeholder = "filter volume names"
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = frc.sections?[section] else { return 0 }
        if isFiltering(){
            return filtered.count
        }else {
            return section.numberOfObjects
        }
    }
    fileprivate lazy var frc : NSFetchedResultsController<Volume> = {
        let volumeFetch : NSFetchRequest<Volume> = Volume.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Volume.number), ascending: true)
        volumeFetch.sortDescriptors = [sortDescriptor]
        let  fetchedResultsController = NSFetchedResultsController(fetchRequest: volumeFetch, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    
    fileprivate func fetchVolumes(){
        do {
            try frc.performFetch()
        }
        catch {
            print(" unable to fetch volumes")
            print("\(error), \(error.localizedDescription)")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VolumeCell", for: indexPath) as! VolumeCell
        cell.configure(with: volume(at: indexPath))
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { fatalError()}
        tableView.deselectRow(at: indexPath, animated: true)
        guard let view = segue.destination as? VolumeDetailsTableViewController else {fatalError("wrong kind of viewController")}
        view.inject(volume(at: indexPath))
    }
    func volume(at indexPath: IndexPath)-> Volume{
        if isFiltering(){
            return filtered[indexPath.row]
        }else {
            return frc.object(at: indexPath)
        }
    }
}

extension VolumesTableViewController : NeedsContainer{
    func assertDependencies() {
        assert(container != nil, "Didnt get a container passed in.")
    }
}

