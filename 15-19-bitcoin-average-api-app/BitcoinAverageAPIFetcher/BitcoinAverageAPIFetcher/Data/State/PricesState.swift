//
//  PricesState.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/9/19.
// ✌️
//

import Combine
import CypherPoetSwiftUIKit
import SatoshiVSKit


struct PricesState {
    var pricesIndexData: [BitcoinPrice] = []
}


enum PricesSideEffect: SideEffect {
    case fetchCurrentPricesList
    
    
    func mapToAction() -> AnyPublisher<AppAction, Never> {
        switch self {
        case .fetchCurrentPricesList:
            return Just(AppAction.prices(.setCurrentPricesList(with: [])))
                .eraseToAnyPublisher()
        }
    }
}



enum PricesAction {
    case setCurrentPricesList(with: [BitcoinPrice])
}



// MARK: - Reducer
let pricesReducer = Reducer<PricesState, PricesAction> { state, action in
    
}
