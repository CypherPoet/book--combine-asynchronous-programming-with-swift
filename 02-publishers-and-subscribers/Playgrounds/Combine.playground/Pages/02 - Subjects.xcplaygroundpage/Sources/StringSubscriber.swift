import Foundation
import Combine

public enum MyError: Error {
    case oops
}


public final class StringSubscriber: Subscriber {
    public typealias Input = String
    public typealias Failure = CustomError

    public init() {}
}

extension StringSubscriber {
    
    public func receive(subscription: Subscription) {
        subscription.request(.max(2))
    }
    
    
    public func receive(_ input: String) -> Subscribers.Demand {
        print("String Subscriber -- Recevied input: \(input)")
        
        return input == "World" ? .max(1) : .none
    }
    
    
    public func receive(completion: Subscribers.Completion<Failure>) {
        print("String Subscriber -- Received completion: \(completion)")
    }
}
