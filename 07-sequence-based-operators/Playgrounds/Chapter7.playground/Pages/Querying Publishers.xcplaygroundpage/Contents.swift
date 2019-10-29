//: [Previous](@previous)

import Foundation
import Combine


//: Some operators also deal with the entire set of values emitted by a publisher,
//: but they don't produce any specific value that it emits.
//:
//: Instead, these operators emit a different value representing some query on
//: the publisher as a whole.


var subscriptions = Set<AnyCancellable>()


demo(describing: "The `count()` operator") {
    let letters = ["A", "B", "C"]
    
    letters
        .publisher
        .print("publisher")
        .count()
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



demo(describing: "The `contains()` operator") {
    let letters = ["A", "B", "C", "D", "E"]
    
    letters
        .publisher
        .print("publisher")
//        .contains("C")
        .contains("8")
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



demo(describing: "The `contains(where:)` operator") {
    struct Ship {
        let name: String
        let speed: Int
    }
    
    let ships = [
        ("Normandy", 220),
        ("Oculus", 22),
        ("Sovereign", 300),
    ]
    .map(Ship.init)
    .publisher
    
        
    ships
        .contains(where: { $0.name == "Normandy" })
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



demo(describing: "The `allSatisfy` operator") {
    let evens = stride(from: 0, to: 10, by: 2)
    let naturals = stride(from: 0, to: 5, by: 1)
    
    
    evens
//    naturals
        .publisher
            .allSatisfy({ $0.isMultiple(of: 2) })
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





demo(describing: "The `reduce` operator") {
    let numbers = [1, 1, 2, 3, 5, 8, 13, 21, 34]
    
    
    numbers
        .publisher
        .reduce(1, { (accumulated, current) in
            accumulated * current
        })
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
