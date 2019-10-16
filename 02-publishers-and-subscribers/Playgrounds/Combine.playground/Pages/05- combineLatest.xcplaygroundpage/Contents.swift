//: [Previous](@previous)

import Foundation
import Combine

//: `combineLatest` is another operator that lets you combine different publishers.
//: It also lets you combine publishers of different
//: value types, which can be extremely useful.


var subscriptions = Set<AnyCancellable>()


demo(describing: "The `combineLatest` operator") {
    let numberStream = PassthroughSubject<Int, Never>()
    let stringStream = PassthroughSubject<String, Never>()
    
    numberStream
        .combineLatest(stringStream)
        .sink(receiveCompletion: { (completion) in
            print("(sink) Received Completion: \(completion)")
        }, receiveValue: { (number, string) in
            print("(sink) Receive Value -- number: \(number)")
            print("(sink) Receive Value -- string: \(string)")
        })
        .store(in: &subscriptions)
    

    numberStream.send(1)
    numberStream.send(2)
    numberStream.send(3)
    
    stringStream.send("Foo")
    stringStream.send("Bar")
    stringStream.send("Baz")
    stringStream.send("Wha?")
    numberStream.send(7)
    stringStream.send("Whoa!")
    
    numberStream.send(completion: .finished)
    stringStream.send(completion: .finished)
}



//: [Next](@next)
