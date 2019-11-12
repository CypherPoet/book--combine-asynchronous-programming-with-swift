//
//  PricesState.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/9/19.
// ✌️
//

import Foundation
import Combine
import CypherPoetSwiftUIKit
import SatoshiVSKit


struct PricesState {
    var indexDataFetchError: BitcoinAverageAPIService.Error? = nil
    var pricesIndexData: [BitcoinPrice] = []
}


enum PricesSideEffect: SideEffect {
    case fetchLatestIndexPrices
    
    
    func mapToAction() -> AnyPublisher<AppAction, Never> {
        switch self {
        case .fetchLatestIndexPrices:
            return Dependencies.bitcoinAverageAPIService
                .tickerDataList(for: Dependencies.supportedShitcoins)
                .receive(on: DispatchQueue.main)
                .map { prices in
                    AppAction.prices(.setPriceIndexData(prices))
                }
                .catch { error in
                    Just(AppAction.prices(.fetchLatestIndexPrices(error: error)))
                }
                .eraseToAnyPublisher()
        }
    }
}



enum PricesAction {
    case setPriceIndexData([BitcoinPrice])
    case fetchLatestIndexPrices(error: BitcoinAverageAPIService.Error)
}



// MARK: - Reducer
let pricesReducer = Reducer<PricesState, PricesAction> { state, action in
    switch action {
    case let .setPriceIndexData(prices):
        state.pricesIndexData = prices
    case let .fetchLatestIndexPrices(error):
        state.indexDataFetchError = error
    }
}
