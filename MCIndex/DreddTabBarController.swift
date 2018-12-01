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
        for view in viewControllers! {
            if let volumeView = view as? VolumesTableViewController {
                print("got a volume view")
            volumeView.inject(dataModel.container)
            }
            if let seriesView = view as? SeriesTableViewController {
                print("got a series view")
                seriesView.inject(dataModel.container)
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension DreddTabBarController : Injectable {
    func inject(_ dm: DataModel) {
        dataModel = dm
    }
    

    func assertDependencies() {
        assert(dataModel  != nil,"no datamodel passes into Dredd TabBarController")
    }
    
    
    typealias T = DataModel
    
    
}
