//
//  WarningMessage.swift
//  Dredd Mega Index
//
//  Created by Simon Gardener on 16/03/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import Foundation
import UIKit

struct Warning {
    static func message()->UIAlertController{
        let warningMessage = """
The 'from' and 'to' fields need to be whole numbers in range 1 to 90.

Both need to have a number.

The 'to' field must be greater or equal to the 'from' field.
"""
        let alert = UIAlertController(title: "Bad numbers", message: warningMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
    
   static func confirm(message: String, completion : ())-> UIAlertController {
        let alertController = UIAlertController(title: "Confirm Changes", message: message, preferredStyle: .alert )
        let continueAction =  UIAlertAction(title: "Go ahead", style: .default, handler:{ _ in
            completion
            
        })
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertController.addAction(continueAction)
        alertController.addAction(cancelAction)
        return alertController
    }
}
