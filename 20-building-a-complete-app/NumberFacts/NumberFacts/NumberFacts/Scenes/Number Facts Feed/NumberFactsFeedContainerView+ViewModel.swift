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
import TranslationService


extension NumberFactsFeedContainerView {

    final class ViewModel: ObservableObject {
        private var subscriptions = Set<AnyCancellable>()

        
        private let numbersAPIService: NumbersAPIServicing
        private let translationAPIService: TranslationAPIServicing
        
            
        // MARK: - Published Outputs
        @Published var dataFetchingState: DataFetchingState = .inactive
        @Published var currentNumberFact: NumberFact?
        @Published var currentLanguage: Language = CurrentApp.defaultLanguage


        // MARK: - Init
        init(
            numbersAPIService: NumbersAPIServicing = NumbersAPIService(),
            translationAPIService: TranslationAPIServicing = TranslationAPIService()
        ) {
            self.numbersAPIService = numbersAPIService
            self.translationAPIService = translationAPIService
            
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
            .flatMap { numberFact in
                self.translationAPIService.fetchTranslationText(
                    for: numberFact.text,
                    convertingFrom: numberFact.currentLanguage,
                    to: numberFact.translationLanguage
                )
                .replaceError(with: "No Translation Available")
            }
            .eraseToAnyPublisher()
    }
}


// MARK: - Computeds
extension NumberFactsFeedContainerView.ViewModel {
    
    var isFetching: Bool { dataFetchingState == .fetching }
}


// MARK: - Public Methods
extension NumberFactsFeedContainerView.ViewModel {
    
    func updateFavoriteStatus(for numberFact: NumberFact, to isFavorite: Bool) {
        guard let context = numberFact.managedObjectContext else { preconditionFailure() }
    
        numberFact.isFavorite = isFavorite
        
        _ = CurrentApp.coreDataManager.save(context)
    }
    
    
    func fetchNumberCard() {
        self.dataFetchingState = .fetching
        
        numbersAPIService
            .fetchRandomMathFactPayload()  // TODO: Enable category selection?
            .retry(1)
            .replaceError(with: NumberFact.errorFactPayload)
            .flatMap { [unowned self] payload in
                self.numbersAPIService.numberFact(
                    fromPayload: payload,
                    in: CurrentApp.coreDataManager.backgroundContext
                )
            }
            .map { numberFact in
                guard let context = numberFact.managedObjectContext else { preconditionFailure() }
                
                numberFact.currentLanguage = CurrentApp.defaultLanguage
                numberFact.translationLanguage = .french
                
                _ = CurrentApp.coreDataManager.save(context)
                
                return numberFact
            }
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
        guard
            let currentNumberFact = currentNumberFact,
            let context = currentNumberFact.managedObjectContext
        else { preconditionFailure() }

        currentNumberFact.translatedText = translationText

        CurrentApp.coreDataManager.save(context)
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
