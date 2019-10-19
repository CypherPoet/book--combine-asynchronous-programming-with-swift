//: [Previous](@previous)

//: Contra dropping, we might have need of receiving values up to some condition is met,
//: and then forcing the publisher to complete.
//:
//: For example, consider a request that may emit an unknown amount of values, but you only want a
//: single emission and don’t care about the rest of them.
//:
//: Combine solves this set of problems with the `prefix` family of operators.
//: Even though the name isn’t entirely intuitive, the abilities these operators provide are
//: useful for many real-life situations.
//:
//: The prefix family of operators is similar to the drop
//: family: `prefix(_:)`, `prefix(while:)` and `prefix(untilOutputFrom:)`.
//:
//: However, instead of dropping values until some condition is met,
//: the prefix operators take values until that condition is met.


import Foundation
import Combine


var subscriptions = Set<AnyCancellable>()


demo(describing: "The `prefix()` operator") {
    let numbers = 1...10
    
    numbers
        .publisher
        .prefix(4)
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


demo(describing: "The `prefix(while:)` operator") {
    let numberSubject = PassthroughSubject<Int, Never>()
    
    numberSubject
        .prefix(while: { $0 < 100 })
        .sink(
            receiveCompletion: { completion in
                print("(sink) Received Completion: \(completion)")
            },
            receiveValue: { value in
                print("(sink) Received Value: \(value)")
            }
        )
        .store(in: &subscriptions)
    
    
    numberSubject.send(20)
    numberSubject.send(40)
    numberSubject.send(60)
    numberSubject.send(100)
    numberSubject.send(160)
}


demo(describing: "The `prefix(untilOutputFrom:)` operator") {
    let theSilencer = PassthroughSubject<Void, Never>()
    let numberSubject = PassthroughSubject<Int, Never>()
    
    
    numberSubject
        .prefix(untilOutputFrom: theSilencer)
        .sink(
            receiveCompletion: { completion in
                print("(numberSubject::sink) Received Completion: \(completion)")
            },
            receiveValue: { value in
                print("(numberSubject::sink) Received Value: \(value)")
            }
        )
        .store(in: &subscriptions)
    
    
    numberSubject.send(20)
    numberSubject.send(40)
    numberSubject.send(60)

    theSilencer.send()

    numberSubject.send(160)
}



//: [Next](@next)
