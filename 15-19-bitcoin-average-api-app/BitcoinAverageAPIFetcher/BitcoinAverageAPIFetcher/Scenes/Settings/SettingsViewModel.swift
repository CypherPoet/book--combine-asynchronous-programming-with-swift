//
//  SettingsViewModel.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/15/19.
// ✌️
//


import SwiftUI
import Combine
import SatoshiVSKit


final class SettingsViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()

    let store: AppStore
    

    // MARK: - Published Properties
    @Published var filteredShitcoins: [Shitcoin] = []


    // MARK: - Init
    init(store: AppStore) {
        self.store = store
        
        setupSubscribers()
    }
}


// MARK: - Publishers
extension SettingsViewModel {

    private var settingsStatePublisher: AnyPublisher<SettingsState, Never> {
        store.$state
            .map(\.settingsState)
            .eraseToAnyPublisher()
    }
    
    
    private var filteredShitcoinsPublisher: AnyPublisher<[Shitcoin], Never> {
        settingsStatePublisher
            .map(\.filteredShitcoins)
            .eraseToAnyPublisher()
    }
}


// MARK: - Computeds
extension SettingsViewModel {
}


// MARK: - Public Methods
extension SettingsViewModel {
}



// MARK: - Private Helpers
private extension SettingsViewModel {

    func setupSubscribers() {
        filteredShitcoinsPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.filteredShitcoins, on: self)
            .store(in: &subscriptions)
    }
}
