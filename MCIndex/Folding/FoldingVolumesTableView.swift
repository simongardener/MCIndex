//
//  FoldingVolumesTableView.swift
//  
//
//  Created by Simon Gardener on 03/12/2018.
//

//unused experiment - may return - keeping here for reference


import UIKit
import FoldingCell
import CoreData

class FoldingVolumesTableViewController: UITableViewController {
    
    var container: NSPersistentContainer!
    
    var cellHeights = [CGFloat]()
    let kOpenCellHeight : CGFloat = 264.0
    let kClosedCellHeight : CGFloat =  74.0
    var previousCellIndexPath : IndexPath?
    var previousCell : VolumeFoldingCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        
        fetchVolumes()
        
        let cellNumber = frc.sections![0].numberOfObjects
        
        for _ in 0...cellNumber {
            cellHeights.append(kClosedCellHeight)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = frc.sections?[section] else {  print("going to return nil for rows in section")
            return 0 }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingVolumeCell", for: indexPath) as! VolumeFoldingCell
        let volume = frc.object(at: indexPath)
        cell.configure(with: volume)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let cell as VolumeFoldingCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        var duration = 0.0
        
        if cellHeights[indexPath.row] == kClosedCellHeight {
            closePreviousCellIfOpen()
            cellHeights[indexPath.row] = kOpenCellHeight //Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
            previousCellIndexPath = indexPath
            previousCell = cell
        }else {
            cellHeights[indexPath.row] = kClosedCellHeight //Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            tableView.beginUpdates()
            tableView.endUpdates()
            }, completion: nil)
    }
    fileprivate func closePreviousCellIfOpen(){
        guard let previousIndexPath = previousCellIndexPath else { return}
        if  cellHeights[previousIndexPath.row] == kOpenCellHeight{
            previousCell?.unfold(false, animated: true, completion:nil)
        }
        
        
    }
//    fileprivate struct C {
//        struct CellHeight {
//            static let close: CGFloat = 85 // equal or greater foregroundView height
//            static let open: CGFloat = 260 // equal or greater containerView height
//        }
//    }
}
extension FoldingVolumesTableViewController : NeedsContainer {
    func assertDependencies() {
        assert(container != nil, "Didnt get a container passed in.")
    }
}
