//: [Previous](@previous)

import Foundation
import Combine


var subscriptions = Set<AnyCancellable>()


demo(describing: "The `zip` operator") {
    let numberStream = PassthroughSubject<Int, Never>()
    let stringStream = PassthroughSubject<String, Never>()
    
    numberStream
        .zip(stringStream)
        .sink(
            receiveCompletion: { (completion) in
                print("(sink) Received Completion: \(completion)")
            },
            receiveValue: { (number, string) in
                print("(sink) Receive Value -- number: \(number)")
                print("(sink) Receive Value -- string: \(string)")
            }
        )
        .store(in: &subscriptions)

    
    [1, 2, 3].forEach { numberStream.send($0) }
    

    stringStream.send("⚡️")
    stringStream.send("🦄")
    stringStream.send("🤐")
    stringStream.send("🍁")
    
    
    numberStream.send(completion: .finished)
    stringStream.send(completion: .finished)
}

//: [Next](@next)
