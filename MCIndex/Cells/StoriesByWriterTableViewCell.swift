//
//  StoriesByWriterTableViewCell.swift
//  MCIndex
//
//  Created by Simon Gardener on 25/02/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import UIKit

class StoriesByWriterTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artists: UILabel!
    @IBOutlet weak var source: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with story : Story) {
        
    }
}
