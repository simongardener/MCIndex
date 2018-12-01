//
//  Injectable.swift
//  MCIndex
//
//  Created by Simon Gardener on 30/11/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import Foundation

protocol Injectable {
    
    associatedtype T
    
    func inject(_ :T)
    func assertDependencies()
    
}
