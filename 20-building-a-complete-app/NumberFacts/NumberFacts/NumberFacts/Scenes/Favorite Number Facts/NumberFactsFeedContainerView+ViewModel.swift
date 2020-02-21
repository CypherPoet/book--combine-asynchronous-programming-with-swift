//
//  NumberFactsFeedContainerView+ViewModel.swift
//  NumberFacts
//
//  Created by CypherPoet on 2/19/20.
// ✌️
//


import SwiftUI
import Combine
import Common
import NumbersAPIService


extension NumberFactsFeedContainerView {

    final class ViewModel: ObservableObject {
        private var subscriptions = Set<AnyCancellable>()

        
        private let numbersAPIService: NumbersAPIServicing
        
            
        // MARK: - Published Outputs
        @Published var dataFetchingState: DataFetchingState = .inactive
        @Published var currentNumberFact: NumberFact?
        @Published var currentLanguage: Language = CurrentApp.defaultLanguage


        // MARK: - Init
        init(
            numbersAPIService: NumbersAPIServicing = NumbersAPIService()
        ) {
            self.numbersAPIService = numbersAPIService
            
            setupSubscribers()
        }
    }
}


// MARK: - Publishers
extension NumberFactsFeedContainerView.ViewModel {

    private var dataFetchingStatePublisher: Publishers.Share<AnyPublisher<DataFetchingState, Never>> {
        $dataFetchingState
            .eraseToAnyPublisher()
            .share()
    }
    
    
    private var numberFactPublisher: AnyPublisher<NumberFact?, Never> {
        dataFetchingStatePublisher
            .map { state in
                guard case let .fetched(numberFact) = state else { return nil }
                return numberFact
            }
            .eraseToAnyPublisher()
    }
    
    
    private var translationTextPublisher: AnyPublisher<String, Never> {
        numberFactPublisher
            .compactMap { $0 }
//            .print("dataFetchingStatePublisher")
            .flatMap { numberFact -> AnyPublisher<String, Never> in
                return Just("Translated numberFact text").eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}


// MARK: - Computeds
extension NumberFactsFeedContainerView.ViewModel {
    
    var isFetching: Bool { dataFetchingState == .fetching }
    
//    var currentNumberFact: NumberFact? {
//        guard case let .fetched(numberFact) = dataFetchingState else { return nil }
//
//        return numberFact
//    }
}


// MARK: - Public Methods
extension NumberFactsFeedContainerView.ViewModel {
    
    func fetchNumberCard() {
        self.dataFetchingState = .fetching
        
        numbersAPIService
            .fetchRandomMathFact()  // TODO: Enable category selection?
            .retry(1)
            .replaceError(with: NumberFact.errorFact)
            .receive(on: DispatchQueue.main)
//            .handleEvents(
//                receiveOutput: { numberFact in
//                    self.dataFetchingState = .fetched(fact: numberFact)
//                }
//            )
            .sink(
                receiveValue: { self.dataFetchingState = .fetched(fact: $0) }
            )
            .store(in: &subscriptions)
    }
}



// MARK: - Private Helpers
private extension NumberFactsFeedContainerView.ViewModel {

    func setupSubscribers() {
        numberFactPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.currentNumberFact, on: self)
            .store(in: &subscriptions)
        
        translationTextPublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { text in
                    print("translationTextPublisher received value: \(text)")
                    self.updateNumberFact(withTranslation: text)
                }
            )
            .store(in: &subscriptions)
    }
    
    
    func updateNumberFact(withTranslation translationText: String) {
//        guard
//            let currentNumberFact = currentNumberFact,
//            let context = currentNumberFact.managedObjectContext
//        else { preconditionFailure() }
//        
//        currentNumberFact.translatedText = translationText
//        
//        CurrentApp.coreDataManager.save(context)
    }
}



extension NumberFactsFeedContainerView.ViewModel {
    enum DataFetchingState {
        case inactive
        case fetching
        case fetched(fact: NumberFact)
        case errored(Error)
    }
}


extension NumberFactsFeedContainerView.ViewModel.DataFetchingState: Equatable {

    static func == (
        lhs: Self,
        rhs: Self
    ) -> Bool {
        switch (lhs, rhs) {
        case (.inactive, .inactive),
             (.fetching, .fetching),
             (.fetched, .fetched),
             (.errored, .errored):
            return true
        default:
            return false
        }
    }
}
