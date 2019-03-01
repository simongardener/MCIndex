//
//  DreddTabBarController.swift
//  MCIndex
//
//  Created by Simon Gardener on 30/11/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import UIKit
import CoreData
class DreddTabBarController: UITabBarController {
    
    var dataModel : DataModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        for view in viewControllers!  {
            let navView = view as! UINavigationController
            if var view = navView.topViewController as? NeedsContainer {
                view.container = dataModel.container
            }
            //        }
        }
        selectedIndex = 3
        
    }
}
extension DreddTabBarController : Injectable {
    func inject(_ dm: T) {
        dataModel = dm
    }
    
    func assertDependencies() {
        assert(dataModel  != nil,"no datamodel passes into Dredd TabBarController")
    }
    
    typealias T = DataModel
    
    
}
