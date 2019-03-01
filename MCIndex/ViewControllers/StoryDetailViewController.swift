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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Story Details"
        assert(story != nil, "No story passed into StrotyDetails")
        populateLabels()
        
        // Do any additional setup after loading the view.
    }
 
    func populateLabels(){
        storyLabel.text = story.title
        thrillLabel.text = story.seriesName
        sourceLabel.text = story.issuesRun
        volumeLabel.text = String(story.inVolume)+": "+(story.volume?.title)!
        artDroidLabel.text = artDroids() ?? "unknown"
        scriptDroidLabel.text = scriptDroids() ?? "unknown"
        letterDroidLabel.text = letterDroids() ?? "unknown"
        
        if let colorists = colorDroids() {
            colorDroidLabel.text = colorists
            colorDroidLabel.isHidden = false
            colorLabelLabel.isHidden = false
        }else {
            colorLabelLabel.isHidden = true
            colorDroidLabel.isHidden = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func artDroids()-> String? {
        guard let droids = story.artists as? Set<Artist> else {
            return nil
        }
        let droidNames = droids.map{$0.fullName!}
        return droidNames.joined(separator: "\n")
    }
    func scriptDroids()-> String? {
        guard let droids = story.writers as? Set<Writer> else {
            return nil
        }
        let droidNames = droids.map{$0.fullName!}
        return droidNames.joined(separator: "\n")
    }
    func colorDroids()-> String? {
        guard let droids = story.colorists as? Set<Colorist>, !droids.isEmpty else {
            return nil
        }
    
        let droidNames = droids.map{$0.fullName!}
        return droidNames.joined(separator: "\n")
    }
    func letterDroids()-> String? {
        guard let droids = story.letterers as? Set<Letterer> else {
            return nil
        }
        let droidNames = droids.map{$0.fullName!}
        return droidNames.joined(separator: "\n")
    }
}

