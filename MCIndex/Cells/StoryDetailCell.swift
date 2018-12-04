//
//  ThrillDetailCell.swift
//  MCIndex
//
//  Created by Simon Gardener on 04/12/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import UIKit

class StoryDetailCell: UITableViewCell {

    @IBOutlet weak var seriesName: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var source: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with volume:Volume, at index : Int){
        let stories = volume.stories!.sortedArray(using:[NSSortDescriptor(key: "order", ascending: true)]) as! [Story]
        let story = stories[index]
        var theTitle = story.title
        if theTitle == "" { theTitle = story.seriesName}
        title.text = theTitle
        seriesName.text = story.seriesName
        if let issuesRun = story.issuesRun, issuesRun.isEmpty == false {
            source.text = issuesRun
        }else {
            source.text = "unknown"
        }	
    }
}
