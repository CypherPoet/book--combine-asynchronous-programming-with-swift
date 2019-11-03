//
//  CurrentCollageContainerViewModel.swift
//  Collage
//
//  Created by CypherPoet on 11/3/19.
// ✌️
//

import SwiftUI
import Combine


final class CurrentCollageContainerViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    
    
    @Published var isPhotoWriterAuthorized: Bool = false
    
    
    init() {
        setupSubscribers()
    }
}



// MARK: - Publishers
extension CurrentCollageContainerViewModel {
}




// MARK: - Private Helpers
private extension CurrentCollageContainerViewModel {
    
    func setupSubscribers() {
        PhotoWriter.isAuthorized
            .receive(on: DispatchQueue.main)
//            .print("CurrentCollageContainerViewModel - PhotoWriter.isAuthorized")
            .assign(to: \.isPhotoWriterAuthorized, on: self)
            .store(in: &subscriptions)
    }
}
