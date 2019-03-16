//
//  StoryDetailViewController.swift
//  MCIndex
//
//  Created by Simon Gardener on 26/02/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import UIKit
import CoreData
class StoryDetailViewController: UIViewController {

    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var thrillLabel: UILabel!
    @IBOutlet weak var artDroidLabel: UILabel!
    @IBOutlet weak var letterDroidLabel: UILabel!
    @IBOutlet weak var colorDroidLabel: UILabel!
    @IBOutlet weak var scriptDroidLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var colorLabelLabel: UILabel!
   
    var story:Story!
    enum Droids :String {
        case artists,writers,colorists,letterers
    }
    
    let nameKey = "fullName"
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Story Details"
        assert(story != nil, "No story passed into StoryDetails")
        populateLabels()
    }
    
    func populateLabels(){
        storyLabel.text = story.title
        thrillLabel.text = story.seriesName
        sourceLabel.text = story.issuesRun
        volumeLabel.text = String(story.inVolume)+": "+(story.volume?.title)!
        artDroidLabel.text = droids(for: Artist.self, withKey: Droids.artists.rawValue) ?? "unknown"
        scriptDroidLabel.text = droids(for: Writer.self, withKey: Droids.writers.rawValue) ?? "unknown"
        letterDroidLabel.text = droids(for: Letterer.self, withKey: Droids.letterers.rawValue) ?? "unknown"
        
        if let colorists = droids(for: Colorist.self, withKey: Droids.colorists.rawValue) {
            colorDroidLabel.text = colorists
            colorDroidLabel.isHidden = false
            colorLabelLabel.isHidden = false
        }else {
            colorLabelLabel.isHidden = true
            colorDroidLabel.isHidden = true
        }
    }
    /// a generic function that takes a creator type and returns a string of the creator names
    ///replaces seperate functions for  letterer, artists, writters and colorists
    /// - Parameters:
    ///   - key: relationShip name
    /// - Returns: a string of creator names seperated by newline
    func droids<T:NSManagedObject>(for _ :T.Type, withKey key : String) -> String? {
        guard let droids = story.value(forKeyPath: key) as? Set<T>, !droids.isEmpty  else { return nil}
        let droidNames = droids.map{$0.value(forKey: nameKey)! as! String}
        return droidNames.joined(separator: "\n")
    }
}
