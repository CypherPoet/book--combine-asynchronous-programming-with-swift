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
    private let prices: [BitcoinPrice]
    private let pricesFetchError: BitcoinAverageAPIService.Error?
    
    
    // MARK: - Published Properties
    
    @Published var displayedPrices: [BitcoinPrice] = []
    @Published var symbolFilters: [Shitcoin.CurrencySymbol] = []
    @Published var isShowingPricesFetchError: Bool = false
    
    
    // MARK: - Init
    init(store: AppStore) {
        self.store = store
        
        self.prices = store.state.pricesState.pricesIndexData
        self.displayedPrices = self.prices
        self.pricesFetchError = store.state.pricesState.indexDataFetchError
        
        setupSubscribers()
    }
}


// MARK: - Publishers
extension PricesListViewModel {

    private var allPricesPublisher: AnyPublisher<[BitcoinPrice], Never> {
        CurrentValueSubject(prices)
            .eraseToAnyPublisher()
    }
    
    
    private var filteredPricesPublisher: AnyPublisher<[BitcoinPrice], Never> {
        allPricesPublisher
            .map { prices in
                prices.filter { self.symbolFilters.contains($0.shitcoinSymbol) }
            }
            .eraseToAnyPublisher()
    }
    
    
    private var displayedPricesPublisher: AnyPublisher<[BitcoinPrice], Never> {
        Publishers.CombineLatest(allPricesPublisher, $symbolFilters)
            .flatMap { (_, activeSymbols) in
                activeSymbols.isEmpty ?
                    self.allPricesPublisher
                    : self.filteredPricesPublisher
            }
            .eraseToAnyPublisher()
    }
    
    
    private var pricesFetchErrorPublisher: AnyPublisher<BitcoinAverageAPIService.Error, Never> {
        CurrentValueSubject(pricesFetchError)
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
}


// MARK: - Computeds
extension PricesListViewModel {
    var displayedPricesCount: Int { displayedPrices.count }
    
    var pricesFetchErrorMessage: String {
        pricesFetchError?.errorDescription ?? ""
    }
}


// MARK: - Private Helpers
private extension PricesListViewModel {

    func setupSubscribers() {
        displayedPricesPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.displayedPrices, on: self)
            .store(in: &subscriptions)
        
        
        pricesFetchErrorPublisher
            .map { _ in true }
            .assign(to: \.isShowingPricesFetchError, on: self)
            .store(in: &subscriptions)
    }
}
