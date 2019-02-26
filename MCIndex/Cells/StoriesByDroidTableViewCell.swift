//
//  StoriesByDroidTableViewCell.swift
//  MCIndex
//
//  Created by Simon Gardener on 25/02/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import UIKit

class StoriesByDroidTableViewCell: UITableViewCell {

    @IBOutlet weak var redBlock: UIView!
    @IBOutlet weak var title: UILabel!
//    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var volumeNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        redBlock.layer.cornerRadius = 16
        redBlock.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(with story: Story){
        volumeNumber.text = "\(story.inVolume)"
        var theTitle = story.title
        if theTitle == "" { theTitle = story.seriesName}
        title.text = theTitle
//        if let issuesRun = story.issuesRun, issuesRun.isEmpty == false {
//            source.text = issuesRun
//        }else {
//            source.text = "unknown"
//        }
    }
}

