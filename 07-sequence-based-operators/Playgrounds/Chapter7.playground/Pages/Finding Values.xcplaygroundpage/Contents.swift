//: [Previous](@previous)

import Foundation
import Combine

//: The min operator lets you find the minimum value emitted by a publisher.
//:
//: It's greedy, which means it must wait for the publisher to send a `.finished` completion event.
//: Once the publisher completes, only the minimum value is emitted by the operator.

var subscriptions = Set<AnyCancellable>()


demo(describing: "The `min()` operator") {
    let numbers = [1, -50, 244, 90, 0]

    numbers
        .publisher
        .print("numbers")
        .min()
        .sink(
            receiveCompletion: { completion in
                print("(sink) Received Completion: \(completion)")
            },
            receiveValue: { value in
                print("(sink) Received Value: \(value)")
            }
        )
        .store(in: &subscriptions)
}


demo(describing: "The `min(by:)` operator for custom `Comparable` logic") {
    let strings = [
        "Combine",
        "Swift for Tensorflow",
        "Animtion",
        "A",
        "12345"
    ]
    
    
    strings
        .publisher
        .print("Publisher")
        .compactMap( { $0.data(using: .utf8) })
        .min(by: { $0.count < $1.count })
        .sink(
            receiveCompletion: { completion in
                print("(sink) Received Completion: \(completion)")
            },
            receiveValue: { value in
                print("(sink) Received Value: \(String(data: value, encoding: .utf8) ?? "")")
            }
        )
        .store(in: &subscriptions)
}


demo(describing: "The `first()` operator") {
    let numbers = (0...9).map { _ in Int.random(in: 1...20) }
    
    numbers
        .publisher
        .print("Publisher")
        .first()
        .sink(
            receiveCompletion: { completion in
                print("(sink) Received Completion: \(completion)")
            },
            receiveValue: { value in
                print("(sink) Received Value: \(value)")
            }
        )
        .store(in: &subscriptions)
}



demo(describing: "The `first(where:)` operator") {
    let numbers = (0...9).map { _ in Int.random(in: 1...20) }
    
    numbers
        .publisher
        .print("Publisher")
        .first(where: { $0 < 5 })
        .sink(
            receiveCompletion: { completion in
                print("(sink) Received Completion: \(completion)")
            },
            receiveValue: { value in
                print("(sink) Received Value: \(value)")
            }
        )
        .store(in: &subscriptions)
}



demo(describing: "The `last()` operator") {
    let numbers = (0...9).map { _ in Int.random(in: 1...20) }
    
    numbers
        .publisher
        .print("Publisher")
        .last()
        .sink(
            receiveCompletion: { completion in
                print("(sink) Received Completion: \(completion)")
            },
            receiveValue: { value in
                print("(sink) Received Value: \(value)")
            }
        )
        .store(in: &subscriptions)
}


demo(describing: "The `output(at:)` operator") {
    let numbers = [1, 1, 2, 3, 5, 8, 13]
    
    numbers
        .publisher
        .print("publisher")
        .output(at: 3)
        .sink(
            receiveCompletion: { completion in
                print("(sink) Received Completion: \(completion)")
            },
            receiveValue: { value in
                print("(sink) Received Value: \(value)")
            }
        )
        .store(in: &subscriptions)
        
}



//: While `output(at:)` emits a single value emitted in a specified index,
//: output(in:) emits values whose indices are within a provided range.


demo(describing: "The `output(in:)` operator") {
    let numbers = [1, 1, 2, 3, 5, 8, 13]
    
    numbers
        .publisher
        .print("publisher")
        .output(in: 2...14)
        .sink(
            receiveCompletion: { completion in
                print("(sink) Received Completion: \(completion)")
            },
            receiveValue: { value in
                print("(sink) Received Value: \(value)")
            }
        )
        .store(in: &subscriptions)
}

//: [Next](@next)
