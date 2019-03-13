//
//  VolumeDetailsTableViewController.swift
//  MCIndex
//
//  Created by Simon Gardener on 28/02/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import UIKit
//
//  VolumeDetailTableViewController.swift
//  MCIndex
//
//  Created by Simon Gardener on 04/12/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import UIKit

class VolumeDetailsTableViewController: UITableViewController {
    
    var volume: Volume!
    var stories: [Story]!
    enum TableSection : Int, CaseIterable {
        case title, cover, story, published, owned
    }
    let cellId = ["VolumeCell","CoverCell", "StoryCell","PublishedCell", "SwitchCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        stories = volume.stories!.sortedArray(using:[NSSortDescriptor(key: "order", ascending: true)]) as? [Story]
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
            
        case TableSection.cover.rawValue:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId[indexPath.section], for: indexPath) as! ArtistCell
            
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

        case TableSection.owned.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId[indexPath.section], for: indexPath) as! SwitchTableViewCell
            cell.switch.isOn = volume.owned
            return cell
        default:
            fatalError("There is no default")
            return UITableViewCell()
        }
    }
    
    @IBAction func ownedChanged(_ sender: UISwitch) {
        volume.owned = sender.isOn
        if UserDefaults.shouldShowVolumeOwnership() {
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        UserDefaults.setShowVolumeOwnership(to: UserDefaults.shouldShowVolumeOwnership())
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? StoryDetailViewController else { fatalError("Not a StoryDetailVC")}
        guard let indexPath = tableView.indexPathForSelectedRow else{fatalError("no valid selected indexpath")}
        vc.story = stories[indexPath.row]
    }
}

extension VolumeDetailsTableViewController : Injectable {
    func inject(_ vol: Volume) {
        volume = vol
    }
    
    func assertDependencies() {
        assert(volume != nil, "volume details table view controller was not passed a volume")
    }
    
    typealias T = Volume
    
}

