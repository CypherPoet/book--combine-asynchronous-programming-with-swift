//
//  Dependencies.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/10/19.
// ✌️
//

import Foundation
import SatoshiVSKit


enum Dependencies {
    static let bitcoinAverageAPIService = BitcoinAverageAPIService(
        queue: DispatchQueue(label: "BitcoinAverageAPI", qos: .userInitiated, attributes: [.concurrent])
    )
}
