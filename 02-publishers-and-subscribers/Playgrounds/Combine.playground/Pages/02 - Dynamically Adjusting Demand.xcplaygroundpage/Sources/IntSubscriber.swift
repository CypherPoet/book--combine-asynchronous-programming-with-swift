import Foundation
import Combine

//
//public final class IntSubscriber: Subscriber {
//    public typealias Input = Int
//    public typealias Failure = Never
//    
//    public init() {}
//}
//
//
//extension IntSubscriber {
//
//    public func receive(subscription: Subscription) {
//        subscription.request(.max(2))
//    }
//
//
//    public func receive(_ input: Input) -> Subscribers.Demand {
//        print("(Subscriber) Received Input: \(input)")
//
//        switch input {
//        case 1:
//            return .max(2)
//        case 3:
//            return .max(1)
//        default:
//            return .none
//        }
//    }
//
//
//    public func receive(completion: Subscribers.Completion<Failure>) {
//        print("(Subscriber) Received completion: \(completion)")
//    }
//    
//}
