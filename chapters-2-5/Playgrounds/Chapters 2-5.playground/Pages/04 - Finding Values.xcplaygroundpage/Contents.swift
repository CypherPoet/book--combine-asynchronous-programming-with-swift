//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

let numbers = (0...30)
    .map { _ in Int.random(in: 1...10_000) }


demo(describing: "The `first(where:)` operator") {
    numbers
        .publisher
        .print("numbers: ")
        .first(where: { $0.isMultiple(of: 3) })
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


//: As opposed to `first(where:)`, the `last(where:)` operator is greedy since it
//: must wait for all values to emit to know whether
//: a matching value has been found.

demo(describing: "The `last(where:)` operator") {
    numbers
        .publisher
        .print("numbers: ")
        .last(where: { $0.isMultiple(of: 3) })
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


demo(describing: "Force-completing otherwise-perpetual publishers") {
    let subject = PassthroughSubject<Int, Never>()
    
    subject
        .last(where: { $0.isMultiple(of: 7) })
        .sink(
            receiveCompletion: { completion in
                print("(sink) Received Completion: \(completion)")
            },
            receiveValue: { value in
                print("(sink) Received Value: \(value)")
            }
        )
        .store(in: &subscriptions)
    
    
    subject.send(2)
    subject.send(4)
    subject.send(8)
    subject.send(7)
    subject.send(7 * 2)
    subject.send(7 * 3)
    
    // Still no completions...
    subject.send(completion: .finished)
}


//: [Next](@next)
