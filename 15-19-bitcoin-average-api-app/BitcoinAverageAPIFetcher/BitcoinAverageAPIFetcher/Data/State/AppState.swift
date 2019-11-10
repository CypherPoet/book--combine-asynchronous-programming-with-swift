//
//  AppState.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/9/19.
// ✌️
//

import SwiftUI
import CypherPoetSwiftUIKit


struct AppState {
    var pricesState = PricesState()
    var settingsState = SettingsState()
}


enum AppAction {
    case prices(_ pricesAction: PricesAction)
    case settings(_ settingsAction: SettingsAction)
}


//enum AppSideEffect: SideEffect {}


// MARK: - Reducer
let appReducer = Reducer<AppState, AppAction> { appState, action in
    switch action {
    case let .prices(action):
        pricesReducer.reduce(&appState.pricesState, action)
    case let .settings(action):
        settingsReducer.reduce(&appState.settingsState, action)
    }
}


typealias AppStore = Store<AppState, AppAction>
