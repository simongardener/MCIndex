//
//  CreditViewController.swift
//  Dredd Mega Index
//
//  Created by Simon Gardener on 13/03/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import UIKit

class CreditViewController: UIViewController {

    @IBOutlet weak var creditMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        creditMessage.text  = """
        This app would not exist without the two Squaxx, Mark Wolstenholme and Michael Briggs, who provided the data sets that powers it.
        
        Mark supplied the data for the first version of this app, then Michael went thru every volume noting down the writers, artists, colorists and letterers.
        
        Thank you both,
        
        Simon Gardener
        (Code Monkey in Chief).
        
        
        Please send any corrections or comments to dredd@20thCenturyFish.co.uk
        """
        
        // Do any additional setup after loading the view.
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
