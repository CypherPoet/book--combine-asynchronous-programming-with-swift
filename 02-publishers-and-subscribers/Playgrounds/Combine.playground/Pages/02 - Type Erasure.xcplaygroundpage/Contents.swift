//: [Previous](@previous)

import Foundation
import Combine


demo(describing: "Type Erasure") {
    var subscriptions = Set<AnyCancellable>()
    let subject = PassthroughSubject<String, Never>()
    let publisher = subject.eraseToAnyPublisher()
    

    publisher
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    subject.send("⚡️")
    subject.send("🦄")
    
}

//: [Next](@next)
