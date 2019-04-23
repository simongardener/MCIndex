//
//  StoriesByArtistTableViewController.swift
//  MCIndex
//
//  Created by Simon Gardener on 22/02/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import UIKit
import CoreData

class StoriesByArtistTableViewController:SearchingTableViewController {
    var container : NSPersistentContainer!
    var droidName : String!
    let cellID = "StoriesByArtist"
    
    var filtered = [Story]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        title = droidName
        fetchStories()
        if let storyCount = frc.fetchedObjects?.count, storyCount > 12 {
            setupSearchController()
        }
    }
    override func setupSearchController() {
        super.setupSearchController()

        searchController.searchBar.placeholder = "filter story title"
    }

    override func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filtered = (frc.fetchedObjects?.filter { $0.title!.lowercased().contains(searchText.lowercased())})!
        tableView.reloadData()
    }
//    fileprivate func hideSearchBar(yAxisOffset : Double){
//        self.tableView.contentOffset = CGPoint(x:0.0, y:yAxisOffset)
//    }
    
    fileprivate lazy var frc : NSFetchedResultsController<Story> = {
        let storyFetch : NSFetchRequest<Story> = Story.fetchRequest()
        var path = "artists.fullName"
        let predicate = NSPredicate(format: "%K contains %@",path, droidName)
        let seriesSort = NSSortDescriptor(key: #keyPath(Story.seriesName), ascending: true)
        let titleSort = NSSortDescriptor(key: #keyPath(Story.title), ascending: true)
        storyFetch.predicate = predicate
        storyFetch.sortDescriptors = [seriesSort, titleSort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: storyFetch, managedObjectContext: container.viewContext, sectionNameKeyPath: #keyPath(Story.seriesName) , cacheName: nil)
        return fetchedResultsController
    }()
    
    fileprivate func fetchStories(){
        do{
            try frc.performFetch()
        }catch{
            print("\(error), \(error.localizedDescription)")
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if isFiltering() {
            return 1
        } else {
            return frc.sections?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){
            return filtered.count
        }else {
            let sectionInfo = frc.sections![section]
            return sectionInfo.numberOfObjects
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = frc.sections else { fatalError("No sections in frc")}
        if isFiltering() {return nil}
        let secInfo = sections[section]
        return secInfo.name
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! StoriesByDroidTableViewCell
        let story : Story
        guard let sections = frc.sections else { fatalError("No sections in frc")}
        if isFiltering() {
            story = filtered[indexPath.row]
        } else {
            let secInfo = sections[indexPath.section]
            story = secInfo.objects?[indexPath.row] as! Story
        }
        cell.configure(with: story)
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? StoryDetailViewController else { fatalError("Not a StoryDetailVC")}
        guard let sections = frc.sections else { fatalError("No sections in frc")}
        guard let indexPath = tableView.indexPathForSelectedRow else{fatalError("no valid selected indexPath")}
        let story: Story
        if isFiltering() {
            story = filtered[indexPath.row]
        }else {
            story = (sections[indexPath.section].objects?[indexPath.row] as? Story)!
        }
        vc.story = story
    }
}
extension StoriesByArtistTableViewController : NeedsContainer {
    func assertDependencies() {
        assert(container != nil, "Didnt get a container passed in.")
        assert(droidName != nil, " Didnt geta droid name passed in")
    }
    
}
