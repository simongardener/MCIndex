//
//  SettingsTableViewController.swift
//  Dredd Mega Index
//
//  Created by Simon Gardener on 12/03/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
 let cellID = "SwitchCell"
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 1
//    }


//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        //let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SwitchTableViewCell
//       cell.switch.isOn = UserDefaults.shouldShowVolumeOwnership()
//        return cell
//    }

    @IBAction func showOwnershipChanged(_ sender: UISwitch) {
    UserDefaults.setShowVolumeOwnership(to: sender.isOn)
    }
    
    
    
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
  
}
extension SettingsTableViewController {
    
    
}
