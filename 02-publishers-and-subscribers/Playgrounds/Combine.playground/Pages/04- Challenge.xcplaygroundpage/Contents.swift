//: [Previous](@previous)

//: 🥅 Challenge: Filter all the things
//:
//: Create an example that publishes a collection of numbers from 1 through 100,
//: and use filtering operators to:
//:
//: - Skip the first 50 values emitted by the upstream publisher.
//: - Take the next 20 values after those first 50 values.
//: - Only take even numbers.
//:
//:     The output of your example should produce the following numbers, one per line:
//:
//:     52 54 56 58 60 62 64 66 68 70
//:


import Foundation
import Combine


var subscriptions = Set<AnyCancellable>()


demo(describing: "Challenge for Chapter 4") {
    let numberPublisher = PassthroughSubject<Int, Never>()
    
    numberPublisher
        .dropFirst(50)
        .prefix(20)
        .filter({ $0.isMultiple(of: 2) })
        .sink(
            receiveCompletion: { completion in
                print("(sink) Received completion: \(completion)")
            },
            receiveValue: { value in
                print("(sink) Received value: \(value)")
            }
        )
    .store(in: &subscriptions)
    
    
    for number in (1...100) {
        numberPublisher.send(number)
    }
}

//: [Next](@next)
