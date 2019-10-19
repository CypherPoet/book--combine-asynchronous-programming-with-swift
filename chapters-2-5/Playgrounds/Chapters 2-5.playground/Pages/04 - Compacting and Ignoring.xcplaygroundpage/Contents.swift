//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()


demo(describing: "The `compactMap` operator") {
    let charges = ["12.23", "Free", "N/A", "823", "3391", "-10"]

    charges
        .publisher
        .compactMap(Double.init)
        .sink { print($0) }
        .store(in: &subscriptions)
}


demo(describing: "The `ignoreOutput` operator") {
    let numbers = 1...10_000
    
    numbers
        .publisher
        .ignoreOutput()
        .sink(
            receiveCompletion: { completion in
                print("(sink) Received completion: \(completion)")
            },
            receiveValue: { value in
                print("(sink) Received value: \(value)")
            }
        )
        .store(in: &subscriptions)
}

//: [Next](@next)
