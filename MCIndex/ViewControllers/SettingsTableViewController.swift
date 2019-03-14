//
//  SettingsTableViewController.swift
//  Dredd Mega Index
//
//  Created by Simon Gardener on 12/03/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    var volumes : [Volume]!
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
    }
    // MARK: - Table view data source

 
    let numberOfRows = CellOrder.credits.rawValue + 1

    @IBAction func showOwnershipChanged(_ sender: UISwitch) {
    UserDefaults.setShowVolumeOwnership(to: sender.isOn)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case CellOrder.showOwned.rawValue:
            guard  let cell = tableView.dequeueReusableCell(withIdentifier: CellID.SwitchCell.rawValue, for: indexPath) as? SwitchTableViewCell else {fatalError()}
            cell.switch.isOn = UserDefaults.shouldShowVolumeOwnership()
            return cell
        case CellOrder.setOwnership.rawValue :
            return tableView.dequeueReusableCell(withIdentifier: CellID.OwnershipCell.rawValue , for: indexPath)
        case CellOrder.setRead.rawValue :
            return tableView.dequeueReusableCell(withIdentifier: CellID.ReadCell.rawValue, for: indexPath)
        case CellOrder.credits.rawValue:
            return tableView.dequeueReusableCell(withIdentifier: CellID.CreditCell.rawValue, for: indexPath)
            
        default:
            fatalError()
           
        }
        
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == SegueId.setOwnership.rawValue {
            guard let vc = segue.destination as? ChangeVolumePropertiesViewController else { fatalError("Not a ChangeVolumePropertiesViewController")}
            vc.inject((volumes,"owned",["Mark all as Owned","Mark all as Unowned","owned","unowned"],"Owned" ))
        }
        if segue.identifier == SegueId.setRead.rawValue {
    guard let vc = segue.destination as? ChangeVolumePropertiesViewController else { fatalError("Not a ChangeVolumePropertiesViewController")}
            print("vc = \(vc)")
            print("about to inject")
            vc.inject((volumes,"hasBeenRead",["Mark all as Read","Mark all as Unread","read","unread"],"Read" ))
        }
    }
}

extension SettingsTableViewController {
    enum SegueId: String {
        case showOwned, setOwnership, setRead, credits
    }
    enum CellOrder: Int {
        case showOwned, setOwnership, setRead, credits
    }
    enum CellID :String {
        case  SwitchCell, OwnershipCell,ReadCell, CreditCell
    }
    
}

extension SettingsTableViewController :Injectable{
   
    func inject(_ allVolumes: [Volume]) {
        volumes = allVolumes
    }
    func assertDependencies() {
       assert(volumes != nil, "No Volumes passed in")
    }
    
    typealias T = [Volume]
    
}
