
//
//  OwnedReadTableViewCell.swift
//  Dredd Mega Index
//
//  Created by Simon Gardener on 14/03/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import UIKit

class OwnedReadTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ownedLabel: UILabel!
    @IBOutlet weak var readLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with volume:Volume){
        let ownedText = volume.owned == true ? "yes":"no"
        ownedLabel.text = ownedText
        readLabel.text = volume.hasBeenRead == true ? "yes":"no"
    }
    
}

