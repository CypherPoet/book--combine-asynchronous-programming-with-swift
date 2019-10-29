//
//  CurrentCollageViewModel.swift
//  Collage
//
//  Created by CypherPoet on 10/28/19.
// ✌️
//

import SwiftUI
import Combine


final class CurrentCollageViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()

    private let collageSize: CGSize = .init(width: 320, height: 300)

    
    @Published var collage: ImageCollage
//    @Published var images: [Image] = []
    @Published var isEmpty = true

    
    init(collage: ImageCollage = ImageCollage(name: "", images: [])) {
        self.collage = collage
        setupSubscribers()
    }
}


// MARK: - Computeds
extension CurrentCollageViewModel {
    
    private var isEmptyPublisher: AnyPublisher<Bool, Never> {
        $collage
            .map { $0.images.isEmpty }
            .eraseToAnyPublisher()
    }
    
    
//    private var imagePublisher: AnyPublisher<[Image], Never> {
//        $collage
//            .map { $0.images }
//            .eraseToAnyPublisher()
//    }
}


// MARK: - Private Helpers
private extension CurrentCollageViewModel {
    
    func setupSubscribers() {
        isEmptyPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEmpty, on: self)
            .store(in: &subscriptions)
        
//        
//        imagePublisher
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.images, on: self)
//            .store(in: &subscriptions)
    }
}
