//: [Previous](@previous)

import Foundation
import Combine

demo(describing: "PassthroughSubject") {
    let subscriber = StringSubscriber()
    let subject = PassthroughSubject<String, CustomError>()
    
    subject.subscribe(subscriber)
    
    let subscription = subject.sink(
        receiveCompletion: { completion in
            print("Received completion (sink): \(completion)")
        },
        receiveValue: { value in
            print("Received value (sink): \(value)")
        }
    )
    
//    subject.send("World")
//    subject.send("⚡️")
//    subject.send("🦄")
//    subject.send("World")
//    subject.send("🚀")
    subject.send("Hello")
    subject.send("World")
    
    subscription.cancel()
    
    subject.send("Still there?")
    
    subject.send(completion: .failure(.oops))
    subject.send(completion: .finished)
    subject.send("Value after completion")
}


demo(describing: "CurrentValueSubject") {
    /// Current value subjects must be initialized with an initial value.
    /// New subscribers immediately get that value or the latest value published by that subject.
    let subject = CurrentValueSubject<Int, Never>(0)
    var subscriptions = Set<AnyCancellable>()
    
    subject
        .print()
        .sink(
            receiveCompletion: { completion in
                print("(Sink) received completion: \(completion)")
            },
            receiveValue: { value in
                print("(Sink) received value: \(value)")
            }
        )
        .store(in: &subscriptions)
    
//    print(subject.value)
    subject.send(2)
//    print(subject.value)
    subject.send(99)
    subject.send(921)
//    print(subject.value)
    
    subject.value = 1000

    subject
        .print()
        .sink(receiveValue: { value in
            print("(Sink: Second subscription) received value: \(value)")
        })
        .store(in: &subscriptions)
    
    
    subject.send(completion: .finished)
}
//: [Next](@next)
