//: [Previous](@previous)

import Foundation

import Combine


var subscriptions = Set<AnyCancellable>()

demo(describing: "The `merge` publisher") {
    let numberStream1 = PassthroughSubject<Int, Never>()
    let numberStream2 = PassthroughSubject<Int, Never>()
    
    
    numberStream1
        .merge(with: numberStream2)
        .sink(
            receiveCompletion: { completion in
                print("(sink) Received Completion: \(completion)")
            },
            receiveValue: { value in
                print("(sink) Received Value: \(value)")
            }
        )
        .store(in: &subscriptions)
    
    
    numberStream1.send(111)
    numberStream1.send(111)
    numberStream2.send(222)
    numberStream2.send(222)
    numberStream1.send(111)
    numberStream2.send(222)
    
    numberStream1.send(completion: .finished)
    numberStream2.send(completion: .finished)
}


//: [Next](@next)
