//
//  SettingsState.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/9/19.
// ✌️
//

import SwiftUI
import Combine
import CypherPoetSwiftUIKit
import SatoshiVSKit


struct SettingsState {
    var filteredShitcoins: [Shitcoin] = [.etb, .link, .usd]
}


//enum SettingsSideEffect: SideEffect {
//    case add(shitcoinToFilters: Shitcoin)
//    case remove(shitcoinFromFilters: Shitcoin)
    
//
//    func mapToAction() -> AnyPublisher<AppAction, Never> {
//        switch self {
//        case .add(let shitcoinToFilters):
//        case .remove(let shitcoinFromFilters):
//        }
//    }
//}



enum SettingsAction {
    case add(shitcoinToFilters: Shitcoin)
    case remove(shitcoinFromFilters: Shitcoin)
}



// MARK: - Reducer
let settingsReducer = Reducer<SettingsState, SettingsAction> { state, action in
    switch action {
    case .add(let shitcoin):
        var filteredShitcoins = state.filteredShitcoins
        filteredShitcoins.append(shitcoin)
        
        state.filteredShitcoins = filteredShitcoins.sorted()
    case .remove(let shitcoin):
        if let index = state.filteredShitcoins.firstIndex(of: shitcoin) {
            state.filteredShitcoins.remove(at: index)
        }
    }
}
