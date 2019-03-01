//
//  SeriesTableViewController.swift
//  MCIndex
//
//  Created by Simon Gardener on 30/11/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import UIKit
import CoreData

class SeriesTableViewController: SearchingTableViewController {

    var container : NSPersistentContainer!
    var filtered = [NSFetchedResultsSectionInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        fetchStories()
        setupSearchController()
    }
   
 override func setupSearchController() {
        super.setupSearchController()
        searchController.searchBar.barTintColor = UIColor(white: 0.9, alpha: 0.9)
    }
  
  override func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filtered = frc.sections!.filter { $0.name.lowercased().contains(searchText.lowercased())}
        tableView.reloadData()
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
