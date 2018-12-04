//
//  VolumeTableViewCell.swift
//  MCIndex
//
//  Created by Simon Gardener on 04/12/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import UIKit

class VolumeCell: UITableViewCell {

    @IBOutlet weak var redBlock: UIView!
    @IBOutlet weak var volumeTitle: UILabel!
    @IBOutlet weak var volumeNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        redBlock.layer.cornerRadius = 16
        redBlock.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with volume: Volume){
        volumeTitle.text = volume.title
        volumeNumber.text = "\(volume.number)"
        
    }
}
