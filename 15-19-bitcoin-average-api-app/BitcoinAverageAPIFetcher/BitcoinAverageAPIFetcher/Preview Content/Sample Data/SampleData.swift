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

//
//
//enum SampleAstronautsState {
//    static let `default` = AstronautsState(astronauts: generateSampleAstronauts())
//}
//
//


enum SamplePricesState {
    static let `default` = PricesState()
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
