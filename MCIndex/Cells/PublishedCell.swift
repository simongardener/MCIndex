//
//  DateIssueTableViewCell.swift
//  MCIndex
//
//  Created by Simon Gardener on 04/12/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import UIKit

class PublishedCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var issueNumber: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with volume: Volume){
        
        date.text = date(from: volume.dateReleased!)
        issueNumber.text = "\(volume.issue)"
}

   fileprivate func date(from date: Date) ->String {
    
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yy"
        return formatter.string(from: date)
    }
}
