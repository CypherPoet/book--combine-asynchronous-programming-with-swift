//
//  NumberFormatters.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/11/19.
// ✌️
//

import Foundation


enum NumberFormatters {
    static let priceReading: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 10
        
        return formatter
    }()
}
