//: [Previous](@previous)


import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()


demo(describing: "The `dropFirst` operator") {
    let numbers = (1...10)
    
    numbers
        .publisher
        .dropFirst(4)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}


demo(describing: "The `drop(while:)` operator") {
    let numbers = (1...10)
    
    numbers
        .publisher
        .drop(while: { number in
            print("Evaluating drop(while:) predicate")
            
            return number % 4 != 0
        })
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}


demo(describing: "The `drop(untilOutputFrom:)` operator") {
    let readyFlag = PassthroughSubject<Void, Never>()
    let numberPublisher = PassthroughSubject<Int, Never>()
    
    numberPublisher
        .drop(untilOutputFrom: readyFlag)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    
    numberPublisher.send(1)
    numberPublisher.send(1)
    numberPublisher.send(2)
    numberPublisher.send(3)
    numberPublisher.send(5)
    
    readyFlag.send()
    
    numberPublisher.send(8)
}


//: [Next](@next)
