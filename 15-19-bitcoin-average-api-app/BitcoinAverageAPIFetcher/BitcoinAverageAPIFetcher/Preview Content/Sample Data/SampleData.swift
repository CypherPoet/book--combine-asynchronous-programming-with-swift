//
//  SampleData.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/9/19.
// ✌️
//

import SwiftUI



#if DEBUG

import Foundation
import SatoshiVSKit


enum SamplePriceAverages {
    static let btc1 = PriceAverages(day: 8163.29, week: 8805.76, month: 9890.36)
    static let usdc1 = PriceAverages(day: 8802.22083894, week: 9141.15312427, month: 9100.30598971)
    static let eth1 = PriceAverages(day: 0.02095983, week: 0.02043407, month: 0.02037242)
}

enum SamplePriceChanges {
    static let btc1 = PriceChanges(day: -94.78, week: -1853.25, month: -1405.66)
    static let usdc1 = PriceChanges(day: 46.18554688, week: -452.84570312, month: 264.56445312)
    static let eth1 = PriceChanges(day: 0.00023875, week: 0.00152056, month: -0.00126697)
}

enum SamplePercentChanges {
    static let btc1 = PercentChanges(day: -1.15, week: -18.56, month: -14.74)
    static let usdc1 = PercentChanges(day: 0.52000000, week: -4.87000000, month: 3.08000000)
    static let eth1 = PercentChanges(day: 1.14000000, week: 7.72000000, month: -5.63000000)
}


enum SamplePrices {
    static let `default` = [
        BitcoinPrice(
            mostRecent: Decimal(floatLiteral: 8131.85),
            displaySymbol: "BTC-USD",
            timestamp: TimeInterval(1569746651.0),
            averages: SamplePriceAverages.btc1,
            priceChanges: SamplePriceChanges.btc1,
            percentChanges: SamplePercentChanges.btc1
        ),
        BitcoinPrice(
            mostRecent: Decimal(floatLiteral: 8851.29705660),
            displaySymbol: "BTC-USDC",
            timestamp: TimeInterval(1573365503.0),
            averages: SamplePriceAverages.usdc1,
            priceChanges: SamplePriceChanges.usdc1,
            percentChanges: SamplePercentChanges.usdc1
        ),
        BitcoinPrice(
            mostRecent: Decimal(floatLiteral: 0.02122581),
            displaySymbol: "ETH-BTC",
            timestamp: TimeInterval(1573365449.0),
            averages: SamplePriceAverages.usdc1,
            priceChanges: SamplePriceChanges.usdc1,
            percentChanges: SamplePercentChanges.usdc1
        ),
    ]
}


enum SamplePricesState {
    static let `default` = PricesState(pricesIndexData: SamplePrices.default)
}


enum SampleSettingsState {
    static let `default` = SettingsState()
}


enum SampleAppState {
    static let `default` = AppState(
        pricesState: SamplePricesState.default,
        settingsState: SampleSettingsState.default
    )
}


enum SampleStore {
    static let `default` = AppStore(initialState: SampleAppState.default, appReducer: appReducer)
}


#endif
