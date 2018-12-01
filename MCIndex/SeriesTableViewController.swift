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
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        print("loading series view")
        fetchStories()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
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
        let secInfo = sections[indexPath.section]
        cell.textLabel?.text = secInfo.name
        return cell
    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let storiesVC = segue.destination as! StoriesTableViewController
        let indexPath = tableView.indexPathForSelectedRow!
        let stories = frc.sections?[indexPath.section].objects as! [Story]
        let name = frc.sections?[indexPath.section].name
        storiesVC.title = name
        storiesVC.inject(stories)
    }

}
extension SeriesTableViewController : Injectable {
    
    func inject(_ persistentContainer : NSPersistentContainer) {
        container = persistentContainer
    }
    
    func assertDependencies() {
        assert(container  != nil,"no container passes into Dredd Series TVC")
    }
    
    
    typealias T = NSPersistentContainer
    
  
}
