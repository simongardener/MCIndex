//
//  OptionOrder.swift
//  Dredd Mega Index
//
//  Created by Simon Gardener on 16/03/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import Foundation

protocol OptionOrder {
    associatedtype  OptionOrder: RawRepresentable
}

extension OptionOrder where OptionOrder.RawValue == Int {

    /// this function allows an enum to be used directly in a switch statement, reducing verosity ie "OptionOrder.someValue.rawValue" to  simply "someValue" and restricting the switch to a finite set of values so no default case is needed and compiler will flag missing case
    /// - Parameter position: an Integer, typically from an indexPath
    /// - Returns: an OptionOrder value
    func optionOrder(for position: Int) -> OptionOrder {
        guard let optionsOrder = OptionOrder(rawValue:position) else { fatalError("No position value") }
        return optionsOrder
    }
}
