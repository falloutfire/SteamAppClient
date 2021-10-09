//
//  Numbers.swift
//  SteamApp
//
//  Created by Ilya Manny on 08.10.2021.
//

import Foundation

extension Double {
    var numberForServer: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 8
        numberFormatter.groupingSeparator = " "
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: self) ?? ""
    }
}


extension Int {
    var numberForServer: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 8
        numberFormatter.groupingSeparator = " "
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: self) ?? ""
    }
}
