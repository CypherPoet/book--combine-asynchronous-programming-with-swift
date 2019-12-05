//: [Previous](@previous)

import Foundation
import Combine


var subscriptions = Set<AnyCancellable>()


extension Publisher {
    
    func unwrap<T>() -> Publishers.CompactMap<Self, T>
        where Output == Optional<T>
    {
        compactMap { $0 }
    }
}


demo(describing: "Using our custom `unwrap` operator") {
    let numbers: [Int?] = [1, 1, 2, 3, nil, nil, 13]
    
    numbers
        .publisher
        .unwrap()
        .sink(
            receiveCompletion: { completion in
                print("Received completion: \(completion)")
            },
            receiveValue: { value in
                print("Received value: \(value)")
            }
        )
        .store(in: &subscriptions)
}


//: [Next](@next)
