//
//  UserDefaultsExtensions.swift
//  Dredd Mega Index
//
//  Created by Simon Gardener on 12/03/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import Foundation

struct UserDefaultsKeys {
    static let shouldShowOwnership = "shouldShowVolumeOwnership"
}
extension UserDefaults {

   static func setShowVolumeOwnership(to bool: Bool){
        UserDefaults.standard.set(bool, forKey: UserDefaultsKeys.shouldShowOwnership)
    }
    static func shouldShowVolumeOwnership()-> Bool {
       return UserDefaults.standard.bool(forKey: UserDefaultsKeys.shouldShowOwnership)
    }
}
