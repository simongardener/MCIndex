//
//  CoverArtistCell.swift
//  MCIndex
//
//  Created by Simon Gardener on 04/12/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import UIKit

class ArtistCell: UITableViewCell {

    @IBOutlet weak var coverArtist: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with volume: Volume ){
        coverArtist.text = volume.coverArtist!
    }
}
