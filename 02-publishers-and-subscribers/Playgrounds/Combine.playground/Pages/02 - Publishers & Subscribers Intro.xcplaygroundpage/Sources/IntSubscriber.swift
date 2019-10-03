import Combine


public final class IntSubscriber: Subscriber {
    public typealias Input = Int
    public typealias Failure = Never
    
//    var combineIdentifier: CombineIdentifier
    
    
    public init() {}
    
    
    public func receive(subscription: Subscription) {
//        subscription.request(.max(3))
        subscription.request(.unlimited)
    }
    
    public func receive(_ input: Int) -> Subscribers.Demand {
        print("Subscriber received value: \(input)")
        
        // Tell the publisher that we aren't adjusting the demand after receiving
        return .none
    }
    
    public func receive(completion: Subscribers.Completion<Never>) {
        print("Subscriber received completion: \(completion)")
    }
    
}
