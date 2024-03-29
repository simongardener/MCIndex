//
//  VolumeTableViewCell.swift
//  MCIndex
//
//  Created by Simon Gardener on 04/12/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import UIKit

class VolumeCell: UITableViewCell {

    @IBOutlet weak var readMark: UILabel!
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

    func configure(with volume: Volume, hasReadMark : Bool = false){
        if hasReadMark {
            if UserDefaults.shouldShowReadStatus(){
                readMark.isHidden = !volume.hasBeenRead
            }else{
                readMark.isHidden = true
            }
        }
        volumeTitle.text = volume.title
        volumeNumber.text = "\(volume.number)"
        if UserDefaults.shouldShowVolumeOwnership() {
            redBlock.backgroundColor = volume.owned ? .red: .lightGray
        }else{
            redBlock.backgroundColor = .red
        }
        
    }
}
