//
//  PricesListViewModel.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/10/19.
// ✌️
//


import SwiftUI
import Combine
import SatoshiVSKit


final class PricesListViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()

    private let store: AppStore
    
    
    // MARK: - Published Properties
    
    @Published var displayedPrices: [BitcoinPrice] = []
    @Published var isShowingPricesFetchError: Bool = false
    @Published var pricesFetchErrorMessage: String = ""
    
    
    // MARK: - Init
    init(store: AppStore) {
        self.store = store
        
        setupSubscribers()
    }
}


// MARK: - Publishers
extension PricesListViewModel {
    
    private var pricesStatePublisher: AnyPublisher<PricesState, Never> {
        store.$state
            .map(\.pricesState)
            .eraseToAnyPublisher()
    }
    
    private var allPricesPublisher: AnyPublisher<[BitcoinPrice], Never> {
        pricesStatePublisher
            .map(\.pricesIndexData)
            .eraseToAnyPublisher()
    }
    
    
    private var pricesFetchErrorPublisher: AnyPublisher<BitcoinAverageAPIService.Error, Never> {
        pricesStatePublisher
            .map(\.indexDataFetchError)
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    
    private var pricesFetchErrorMessagePublisher: AnyPublisher<String, Never> {
        pricesFetchErrorPublisher
            .print("pricesFetchErrorMessagePublisher")
            .map { error in
                switch error {
                case let .unsuccessfulStatusCode(data, response):
                    switch response.statusCode {
                    case 429:
                        return "Rate Limited"
                    default:
                        return error.errorDescription
                    }
                default:
                    return error.errorDescription
                }
            }
            .replaceNil(with: "")
            .eraseToAnyPublisher()
    }
}


// MARK: - Computeds
extension PricesListViewModel {
    var displayedPricesCount: Int { displayedPrices.count }
}


// MARK: - Private Helpers
private extension PricesListViewModel {

    func setupSubscribers() {
        allPricesPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.displayedPrices, on: self)
            .store(in: &subscriptions)
        
        
        pricesFetchErrorPublisher
            .receive(on: DispatchQueue.main)
            .map { _ in true }
            .assign(to: \.isShowingPricesFetchError, on: self)
            .store(in: &subscriptions)
        
        
        pricesFetchErrorMessagePublisher
            .print("pricesFetchErrorMessagePublisher receiving")
            .receive(on: DispatchQueue.main)
            .assign(to: \.pricesFetchErrorMessage, on: self)
            .store(in: &subscriptions)
    }
}
