//
//  CoinData.swift
//  ByteCoin
//
//  Created by Gurpreet Singh on 2021-04-19.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Codable {
    let rate: Double
    let asset_id_quote: String
    
    var rateString: String {
        let bigNumber = String(format: "%.2f", rate)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: Double(bigNumber) ?? 0.00))
        return formattedNumber ?? "0.00"
    }
}
