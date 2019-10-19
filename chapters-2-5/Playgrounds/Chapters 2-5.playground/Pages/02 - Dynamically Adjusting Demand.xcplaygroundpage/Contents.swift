//: [Previous](@previous)

import Foundation
import Combine


public final class IntSubscriber: Subscriber {
    public typealias Input = Int
    public typealias Failure = Never
    
    public init() {}
}


extension IntSubscriber {

    public func receive(subscription: Subscription) {
        subscription.request(.max(2))
    }


    public func receive(_ input: Input) -> Subscribers.Demand {
        print("(Subscriber) Received Input: \(input)")
        
        switch input {
        case 1:
            return .max(2)
        case 3:
            return .max(1)
        default:
            return .none
        }
    }


    public func receive(completion: Subscribers.Completion<Failure>) {
        print("(Subscriber) Received completion: \(completion)")
    }
}


demo(describing: "Dynamically Adjusting Demand") {
    let subscriber = IntSubscriber()
    let subject = PassthroughSubject<IntSubscriber.Input, IntSubscriber.Failure>()

    // Starting demand: 2
    subject.subscribe(subscriber)

    // Starting demand: 2... Use 1... Add 2...= 3 remaining
    subject.send(1)
    
    // Starting demand: 3... Use 1... = 2 remaining
    subject.send(2)
    
    // Starting demand: 2... Use 1... Add 1... = 2 remaining
    subject.send(3)
    
    // Starting demand: 2... Use 1... = 1 remaining
    subject.send(4)
    
    // Starting demand: 1... Use 1... = 0 remaining
    subject.send(5)
    
    // This shouldn't be received
    subject.send(6)
}




//: [Next](@next)
