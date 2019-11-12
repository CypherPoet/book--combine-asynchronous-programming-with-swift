//
//  BitcoinPrice+UpdatedAgoText.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/12/19.
// ✌️
//

import Foundation
import SatoshiVSKit


extension BitcoinPrice {

    func updatedAgoText(offsetFrom currentDate: Date) -> String {
        let timeDiff = timestamp - currentDate.timeIntervalSince1970
        
        return "Last updated \(DateFormatters.priceUpdatedAgo.localizedString(fromTimeInterval: timeDiff))"
    }
}






