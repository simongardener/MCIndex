//
//  ExtUIView.swift
//  MCIndex
//
//  Created by Simon Gardener on 26/02/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners() {
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
    }
}
