//
//  NumberFactsState.swift
//  NumberFacts
//
//  Created by CypherPoet on 2/19/20.
// ✌️
//


import Foundation
import Combine
import Common
import CypherPoetSwiftUIKit_DataFlowUtils



// 📝 TODO: Not sure if we need this
    
struct NumberFactsState {
//    var dataFetchingState: DataFetchingState = .inactive
    
//    @UserDefault("number-facts-state-current-language-code")
//    var preferredLanguageCode: String
}


//enum NumberFactsSideEffect: SideEffect {
//
//}


enum NumberFactsAction {
//    case currentLanguageCodeSet(String)
}


//
//extension NumberFactsState {
//    enum DataFetchingState {
//        case inactive
//        case fetching
//        case fetched(fact: NumberFact)
//        case errored(Error)
//    }
//}


//extension NumberFactsState.DataFetchingState: Equatable {
//
//    static func == (
//        lhs: NumberFactsState.DataFetchingState,
//        rhs: NumberFactsState.DataFetchingState
//    ) -> Bool {
//        switch (lhs, rhs) {
//        case (.inactive, .inactive),
//             (.fetching, .fetching),
//             (.fetched, .fetched),
//             (.errored, .errored):
//            return true
//        default:
//            return false
//        }
//    }
//}


// MARK: - Reducer
let numberFactsReducer: Reducer<NumberFactsState, NumberFactsAction> = Reducer(
    reduce: { state, action in
        switch action {
//        case .currentLanguageCodeSet(let code):
//            state.currentLanguageCode = code
        }
    }
)

