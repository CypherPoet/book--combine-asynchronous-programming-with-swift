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
    
    
    static let supportedShitcoins = [
        Shitcoin.eth,
        Shitcoin.usd,
        Shitcoin.usdc,
        Shitcoin(name: "Decred", symbol: "DCR", category: .crypto),
        Shitcoin(name: "Link", symbol: "LINK", category: .token)
    ]
}
