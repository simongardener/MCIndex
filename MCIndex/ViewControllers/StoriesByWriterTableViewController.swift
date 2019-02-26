//
//  StoriesByWriterTableViewController.swift
//  MCIndex
//
//  Created by Simon Gardener on 22/02/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import UIKit
import CoreData
class StoriesByWriterTableViewController: UITableViewController {

    var container : NSPersistentContainer!
    var droidName : String!
    let cellID = "StoriesByWriter"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        title = droidName
        fetchStories()
       
    }

    fileprivate lazy var frc : NSFetchedResultsController<Story> = {
        let storyFetch : NSFetchRequest<Story> = Story.fetchRequest()
        var path = "writers.fullName"
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
            print("Unable to fetch artist")
            print("\(error), \(error.localizedDescription)")
            
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return frc.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let sectionInfo = frc.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = frc.sections else { fatalError("No sections in frc")}
        
        let secInfo = sections[section]
        return secInfo.name
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      //  guard let sections = frc.sections else { fatalError("No sections in frc")}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! StoriesByDroidTableViewCell
       // let secInfo = sections[indexPath.section]
       // let story = secInfo.objects?[indexPath.row] as! Story
        let story = frc.object(at: indexPath)
        cell.configure(with: story)
        return cell
    }


  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! StoryDetailViewController
        let indexPath = tableView.indexPathForSelectedRow!
        vc.story = frc.object(at: indexPath)
    }
}
extension StoriesByWriterTableViewController : NeedsContainer {
    func assertDependencies() {
        assert(container != nil, "Didnt get a container passed in.")
        assert(droidName != nil, " Didnt geta droid name passed in")
    }
    
}
