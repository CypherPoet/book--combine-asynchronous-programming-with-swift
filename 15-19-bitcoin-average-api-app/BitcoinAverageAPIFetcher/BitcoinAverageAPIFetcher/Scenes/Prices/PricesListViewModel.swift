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

    var prices: [BitcoinPrice]
    

    // MARK: - Published Properties
    
    @Published var displayedPrices: [BitcoinPrice] = []
    @Published var symbolFilters: [Shitcoin.CurrencySymbol] = []
    

    // MARK: - Init
    init(prices: [BitcoinPrice] = []) {
        self.prices = prices
        
        setupSubscribers()
    }
}


// MARK: - Publishers
extension PricesListViewModel {

    private var allPricesPublisher: AnyPublisher<[BitcoinPrice], Never> {
        CurrentValueSubject<[BitcoinPrice], Never>(prices)
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
}


// MARK: - Computeds
extension PricesListViewModel {
    var displayedPricesCount: Int { displayedPrices.count }
}


// MARK: - Public Methods
extension PricesListViewModel {
}



// MARK: - Private Helpers
private extension PricesListViewModel {

    func setupSubscribers() {
        displayedPricesPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.displayedPrices, on: self)
            .store(in: &subscriptions)
    }
}
