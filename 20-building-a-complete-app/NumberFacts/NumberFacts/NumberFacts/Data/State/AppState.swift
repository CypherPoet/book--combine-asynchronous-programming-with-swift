//
//  AppState.swift
//  NumberFacts
//
//  Created by CypherPoet on 2/18/20.
// ✌️
//


import Foundation
import Combine
import CypherPoetSwiftUIKit_DataFlowUtils


struct AppState {
    var numberFactsState = NumberFactsState()
}



//enum AppSideEffect: SideEffect {
//
//}



enum AppAction {
    case numberFacts(_ action: NumberFactsAction)
}


// MARK: - Reducer
let appReducer: Reducer<AppState, AppAction> = Reducer(
    reduce: { appState, action in
        switch action {
        case .numberFacts(let action):
            numberFactsReducer.reduce(&appState.numberFactsState, action)
        }
    }
)


typealias AppStore = Store<AppState, AppAction>

