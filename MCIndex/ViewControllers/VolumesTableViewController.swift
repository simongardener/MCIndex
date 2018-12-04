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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        fetchVolumes()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = frc.sections?[section] else { return 0 }
        print("number of volumes = \(section.numberOfObjects)")
        return section.numberOfObjects
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
        let volume = frc.object(at: indexPath)
        cell.configure(with: volume)

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension VolumesTableViewController : NeedsContainer{
    func assertDependencies() {
        assert(container != nil, "Didnt get a container passed in.")
    }
}

