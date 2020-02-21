//
//  NumberFactCardView+ViewModel.swift
//  NumberFacts
//
//  Created by CypherPoet on 2/20/20.
// ✌️
//


import SwiftUI
import Combine
import Common


extension NumberFactCardView {
//    final class ViewModel: ObservableObject {
    struct ViewModel {
//        private var subscriptions = Set<AnyCancellable>()


//         MARK: - Published Outputs
//        @Published var someValue: String = ""
        
        var numberFact: NumberFact
        var language: Language
    }
}

// MARK: - Publishers
extension NumberFactCardView.ViewModel {

    private var someValuePublisher: AnyPublisher<String, Never> {
        Just("")
            .eraseToAnyPublisher()
    }
}


// MARK: - Computeds
extension NumberFactCardView.ViewModel {
}


// MARK: - Public Methods
extension NumberFactCardView.ViewModel {
}



// MARK: - Private Helpers
private extension NumberFactCardView.ViewModel {

//    func setupSubscribers() {
//        someValuePublisher
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.someValue, on: self)
//            .store(in: &subscriptions)
//    }
}
