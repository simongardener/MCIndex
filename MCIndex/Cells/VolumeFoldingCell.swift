//
//  VolumeFoldingCell.swift
//  MCIndex
//
//  Created by Simon Gardener on 03/12/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import UIKit
import FoldingCell

class VolumeFoldingCell: FoldingCell {
  
    @IBOutlet weak var redBlock: UIView!
    @IBOutlet weak var volumeTitle: UILabel!
    
    @IBOutlet weak var volumeNumber2: UILabel!
    @IBOutlet weak var volumeNumber: UILabel!
    @IBOutlet weak var volumeTitle2: UILabel!
    @IBOutlet weak var coverArtist: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        redBlock.layer.cornerRadius = 16
        redBlock.layer.masksToBounds = true
        
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        
        // durations count equal it itemCount
        let durations = [0.33, 0.26, 0.26] // timing animation for each view
        return durations[itemIndex]
    }
    
    func configure(with volume : Volume){
        volumeTitle.text = volume.title
        volumeTitle2.text = volume.title
        volumeNumber.text = "\(volume.number)"
        volumeNumber2.text = "\(volume.number)"
        coverArtist.text = volume.coverArtist
        
    }
}

