//
//  needsContainer.swift
//  MCIndex
//
//  Created by Simon Gardener on 03/12/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import Foundation
import CoreData

protocol NeedsContainer  {
    var container: NSPersistentContainer! {get set}
    func assertDependencies()
}
