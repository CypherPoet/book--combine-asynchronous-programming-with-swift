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

    private let collagePreviewSize: CGSize = .init(width: 320, height: 300)

    
    @Published var collagePreview: ImageCollage
    @Published var sourceImages: [UIImage] = []
    @Published var sourceImageCount: Int = 0
    @Published var isEmpty = true
    @Published var isAddEnabled = true
    @Published var isSaveEnabled = false

    
    init(
        collage: ImageCollage = ImageCollage(name: "New Collage", processedImage: nil)
    ) {
        self.collagePreview = collage
        
        setupSubscribers()
    }
}


// MARK: - Publishers
extension CurrentCollageViewModel {
    
    private var isEmptyPublisher: AnyPublisher<Bool, Never> {
        $collagePreview
            .map { $0.processedImage == nil }
            .eraseToAnyPublisher()
    }
    
    private var imageCountPublisher: AnyPublisher<Int, Never> {
        $sourceImages
            .map { $0.count }
            .eraseToAnyPublisher()
    }
    
    
    private var isSaveEnabledPublisher: AnyPublisher<Bool, Never> {
        imageCountPublisher
            .map { $0 > 0 }
            .eraseToAnyPublisher()
    }
    
    
    private var isAddEnabledPublisher: AnyPublisher<Bool, Never> {
        imageCountPublisher
            .map { $0 < 6 }
            .eraseToAnyPublisher()
    }
    
    
    private var collageImagePublisher: AnyPublisher<UIImage, Never> {
        $sourceImages
            .compactMap({ imageList in
                // 📝 `drop(while:)` doesn't cut it here, because that won't drop again after
                // we start adding images, and then clear then.
                imageList.isEmpty ? nil : imageList
            })
            .combineLatest(isAddEnabledPublisher)
            .prefix(while: { (_, isAddEnabled) in isAddEnabled })
            .map { (images, _) in images }
            .map { UIImage.collage(images: $0, size: self.collagePreviewSize) }
            .eraseToAnyPublisher()
    }
}


// MARK: - Computeds
extension CurrentCollageViewModel {
    
    var sourceImageCountText: String {
        let count = sourceImageCount
        let imageText = count == 1 ? "Image" : "Images"
        
        return "\(count) \(imageText) Selected"
    }
}


// MARK: - Public Methods
extension CurrentCollageViewModel {
    
    func clearCollage() {
        sourceImages.removeAll(keepingCapacity: true)
        collagePreview.processedImage = nil
    }
}



// MARK: - Private Helpers
private extension CurrentCollageViewModel {
    
    func setupSubscribers() {
        isEmptyPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEmpty, on: self)
            .store(in: &subscriptions)
        
        collageImagePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { image in
                self.collagePreview.processedImage = image
            })
            .store(in: &subscriptions)
        
        imageCountPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.sourceImageCount, on: self)
            .store(in: &subscriptions)
        
        isAddEnabledPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isAddEnabled, on: self)
            .store(in: &subscriptions)
        
        isSaveEnabledPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isSaveEnabled, on: self)
            .store(in: &subscriptions)
    }
}
