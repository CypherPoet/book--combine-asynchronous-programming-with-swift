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
    final class ViewModel: ObservableObject {
//        private var subscriptions = Set<AnyCancellable>()
        
        let numberFact: NumberFact

        
        // MARK: - Published Outputs
        @Published var isShowingTranslation = false
        @Published var decisionState: DecisionState = .undecided
        
        // MARK: - Init
        init(numberFact: NumberFact) {
            self.numberFact = numberFact
        }
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
    
    var numberFactText: String {
        isShowingTranslation ? (numberFact.translatedText ?? "No translation available.") : numberFact.text
    }
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


// MARK: - Decision State
extension NumberFactCardView.ViewModel {
    enum DecisionState {
        case liked
        case disliked
        case undecided
    }
}
