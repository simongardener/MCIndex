//
//  VolumesTableViewController.swift
//  MCIndex
//
//  Created by Simon Gardener on 30/11/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import UIKit
import CoreData

class VolumesTableViewController: UITableViewController {
    
    var container: NSPersistentContainer!
    var filtered = [Volume]()
    var searchController = UISearchController(searchResultsController: nil)
    let initialSearchBarOffset = 56.0
    var cancelSearchBarOffset = -8.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        fetchVolumes()
        cancelSearchBarOffset = -1 * (Double((navigationController?.navigationBar.frame.maxY)!) - initialSearchBarOffset)
        setupSearchController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
        searchController.isActive = false
        hideSearchBar(yAxisOffset: cancelSearchBarOffset)
    }
    func setupSearchController() {
        hideSearchBar(yAxisOffset: initialSearchBarOffset)
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.barTintColor = UIColor(white: 0.9, alpha: 0.9)
        searchController.searchBar.placeholder = "Search by volume name"
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
        filtered = (frc.fetchedObjects?.filter { $0.title!.lowercased().contains(searchText.lowercased())})!
        tableView.reloadData()
    }
    fileprivate func hideSearchBar(yAxisOffset : Double){
        self.tableView.contentOffset = CGPoint(x:0.0, y:yAxisOffset)
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
        let volume : Volume
        if isFiltering() {
            volume =  filtered[indexPath.row]
        }else {
            volume = frc.object(at: indexPath)
        }
        cell.configure(with: volume)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { fatalError()}
        tableView.deselectRow(at: indexPath, animated: true)
        guard let view = segue.destination as? VolumeDetailsTableViewController else {fatalError("wrong kind of viewController")}
        let volume : Volume
        if isFiltering() {
            volume = filtered[indexPath.row]
        } else {
            volume = frc.object(at: indexPath)
        }
        view.inject(volume)
    }
}

extension VolumesTableViewController : NeedsContainer{
    func assertDependencies() {
        assert(container != nil, "Didnt get a container passed in.")
    }
}

extension VolumesTableViewController : UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        hideSearchBar(yAxisOffset: cancelSearchBarOffset)
    }
}

extension VolumesTableViewController  : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
