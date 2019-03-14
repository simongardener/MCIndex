//
//  ChangeVolumePropertiesViewController.swift
//  Dredd Mega Index
//
//  Created by Simon Gardener on 13/03/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import UIKit

/// This class is used to change a boolen value on Volume NMO instances
/// specifically either the owned and read properties

class ChangeVolumePropertiesViewController: UIViewController {
    
    var propertyKey :String!
    var ownedOreadLabels : [String]!
    
    enum LabelOrder : Int {
        case markAll, unmarkAll, on, off
    }
    @IBOutlet weak var valuesSegment: UISegmentedControl!
    @IBOutlet weak var markAllButton: UIButton!
    @IBOutlet weak var unMarkAllButton: UIButton!
   
    var volumes : [Volume]!
    let propertyValueisTrue = 0
    let issueNumber = 0
    let volumeNumber = 1
    let issueOrVolumeNumber = ["issue","number"]
    
    @IBOutlet weak var issuesOrVolume: UISegmentedControl!
    
    @IBOutlet weak var ownedOrUnowned: UISegmentedControl!
    
    @IBOutlet weak var fromNumberField: UITextField!
    @IBOutlet weak var toNumberField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        setUpButtonAndLabelText()
    }
    
    func setUpButtonAndLabelText(){
        valuesSegment.setTitle(ownedOreadLabels[LabelOrder.on.rawValue], forSegmentAt: 0)
        valuesSegment.setTitle(ownedOreadLabels[LabelOrder.off.rawValue], forSegmentAt: 1)
        markAllButton.setTitle(ownedOreadLabels[LabelOrder.markAll.rawValue], for: .normal)
        unMarkAllButton.setTitle(ownedOreadLabels[LabelOrder.unmarkAll.rawValue], for: .normal)
    }
    
    @IBAction func markAllOwned(_ sender: Any) {
        markAll(bool: true)
    }
    @IBAction func markAllUnowned(_ sender: Any) {
        markAll(bool: false)
    }
    fileprivate func markAll(bool:Bool){
        set(key: issueOrVolumeNumber[volumeNumber], inRange: 1, to: 90, owned: bool)
    }
    
    @IBAction func setRange(_ sender: Any) {
        guard let lower = validNumberFrom(fromNumberField), let higher = validNumberFrom(toNumberField) else{
            print("not valid numbers")
            return
        }
        let isOwned = ownedOrUnowned.selectedSegmentIndex == propertyValueisTrue ? true:false
        let whichCountingSysytem = issueOrVolumeNumber[issuesOrVolume.selectedSegmentIndex]
        
        set(key: whichCountingSysytem, inRange: lower, to: higher, owned: isOwned)
    }
    
    fileprivate func validNumberFrom(_ textfield: UITextField) -> Int? {
        guard let theText = textfield.text, let number = Int(theText) , number > 0 , number < 91  else { return nil}
        return number
        
    }
    
    fileprivate func set(key: String, inRange from: Int ,to :Int, owned: Bool){
        let indexRange = CountableClosedRange(uncheckedBounds: (from, to))
        if key == issueOrVolumeNumber[volumeNumber] {
            for index in indexRange {
                print("index\(index)")
                volumes[index-1].setValue(owned, forKey: propertyKey)
            }
        }else {
            let filteredVolumes =  volumes.filter{indexRange.contains(Int($0.issue))}
            for volume in filteredVolumes {
                volume.setValue(owned, forKey: propertyKey)
                
            }
        }
        volumesOwnershipStatement()
    }
    fileprivate func volumesOwnershipStatement(){
        for volume in volumes {
            print("volume: \(volume.number)  issue: \(volume.issue) owned:\(volume.owned) read:\(volume.hasBeenRead)\n")
        }
    }
}

extension ChangeVolumePropertiesViewController : Injectable{

    func inject(_ injected: (allVolumes: [Volume], propertyKey: String, labelArray: [String], title:String)) {
        print("inject called")
        volumes = injected.allVolumes
        propertyKey = injected.propertyKey
        ownedOreadLabels = injected.labelArray
        title = injected.title
        print("inject finished")
    }
    
    func assertDependencies() {
        assert(volumes != nil, "volumes doesnt exist")
        assert(propertyKey != nil)
        assert(ownedOreadLabels != nil)
        assert(ownedOreadLabels.count == 4)
    }
    
    typealias T = (allVolumes: [Volume], propertyKey: String, labelArray: [String], title:String)
    
}
extension ChangeVolumePropertiesViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
