//
//  VolumeDetailTableViewController.swift
//  MCIndex
//
//  Created by Simon Gardener on 04/12/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import UIKit

class VolumeDetailTableViewController: UITableViewController {

    var volume: Volume!
    enum TableSection : Int, CaseIterable {
        case title, story, published
    }
    let cellId = ["VolumeCell","StoryCell","PublishedCell"]

    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
    }

    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int{
        return TableSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if section == TableSection.story.rawValue {
            return (volume.stories?.count)!
        }else {
            return 1
        }
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        switch  indexPath.section {
        case TableSection.title.rawValue:
            
          let cell = tableView.dequeueReusableCell(withIdentifier: cellId[indexPath.section], for: indexPath) as! VolumeCell
            cell.configure(with: volume)
            return cell
            
        case TableSection.published.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId[indexPath.section], for: indexPath) as! PublishedCell
            cell.configure(with: volume)
            return cell
            
        case TableSection.story.rawValue:
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId[indexPath.section], for: indexPath) as! StoryDetailCell
            cell.configure(with: volume, at: indexPath.row)
            return cell
        default :
            return UITableViewCell()
     
        }

        

    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension VolumeDetailTableViewController : Injectable {
    func inject(_ vol: Volume) {
        volume = vol
    }
    
    func assertDependencies() {
        assert(volume != nil, "volume details table view controller was not passed a volume")
    }
    
    typealias T = Volume

}

