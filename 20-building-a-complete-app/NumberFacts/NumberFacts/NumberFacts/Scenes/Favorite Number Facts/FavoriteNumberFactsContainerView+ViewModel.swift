//
//  FavoriteNumberFactsContainerView+ViewModel.swift
//  NumberFacts
//
//  Created by CypherPoet on 2/23/20.
// ✌️
//


import SwiftUI
import Combine
import Common
import CoreData
import CypherPoetCoreDataKit


extension FavoriteNumberFactsContainerView {
    final class ViewModel: NSObject, ObservableObject {
        private var subscriptions = Set<AnyCancellable>()

        lazy var fetchRequest: NSFetchRequest<NumberFact> = NumberFact.FetchRequests.favorites
        internal lazy var fetchedResultsController: FetchedResultsController = makeFetchedResultsController()

        
        // MARK: - Published Outputs
        @Published var numberFacts: [NumberFact] = []


        // MARK: - Init
        override init() {
            super.init()
            
            self.fetchedResultsController.delegate = self

            setupSubscribers()
            fetchNumberFacts()
        }
    }
}



// MARK: - Publishers
extension FavoriteNumberFactsContainerView.ViewModel {

//    private var someValuePublisher: AnyPublisher<String, Never> {
//        Just("")
//            .eraseToAnyPublisher()
//    }
}


// MARK: - Computeds
extension FavoriteNumberFactsContainerView.ViewModel {
}


// MARK: - Public Methods
extension FavoriteNumberFactsContainerView.ViewModel {
    
    func fetchNumberFacts() {
        do {
            try fetchedResultsController.performFetch()
            numberFacts = extractResults(from: fetchedResultsController)
        } catch {
            print("Fetch Error: \(error.localizedDescription)")
        }
    }
}


// MARK: - Private Helpers
private extension FavoriteNumberFactsContainerView.ViewModel {
    
    func setupSubscribers() {
        
    }
}


// MARK: - FetchedResultsControlling
extension FavoriteNumberFactsContainerView.ViewModel: FetchedResultsControlling {
    typealias FetchedResult = NumberFact
    var managedObjectContext: NSManagedObjectContext { CurrentApp.coreDataManager.mainContext  }
}



// MARK: - NSFetchedResultsControllerDelegate
extension FavoriteNumberFactsContainerView.ViewModel: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let controller = controller as? FetchedResultsController else { return }

        print("controllerDidChangeContent")
        numberFacts = extractResults(from: controller)
    }
}
