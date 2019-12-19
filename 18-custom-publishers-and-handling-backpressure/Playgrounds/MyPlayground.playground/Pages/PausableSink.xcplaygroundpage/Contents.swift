//: [Previous](@previous)

import Foundation
import Combine


var subscriptions = Set<AnyCancellable>()


public protocol Pausable {
    var isPaused: Bool { get }
    
    func resume()
}


public final class PausableSubscriber<Input, Failure: Error> {
    public typealias ReceiveCompletion = (Subscribers.Completion<Failure>) -> Void
    
    /// A closure that returns  a boolean to indicate whether or not the subscription should pause.
    public typealias ReceiveValueAndContinue = (Input) -> Bool

    public let combineIdentifier = CombineIdentifier()

    /// A closure that returns  a boolean to indicate whether or not the subscription should pause.
    public let receiveValueAndContinue: ReceiveValueAndContinue

    public let receiveCompletion: ReceiveCompletion
    private var subscription: Subscription?
    public var isPaused: Bool
    
    
    /// - Parameters:
    ///   - receiveValueAndContinue: A closure that returns a boolean to indicate whether
    ///         or not the subscription should pause.
    public init(
        receiveValueAndContinue: @escaping ReceiveValueAndContinue,
        receiveCompletion: @escaping ReceiveCompletion,
        subscription: Subscription? = nil,
        isPaused: Bool = false
    ) {
        self.receiveValueAndContinue = receiveValueAndContinue
        self.receiveCompletion = receiveCompletion
        self.subscription = subscription
        self.isPaused = isPaused
    }
}


extension PausableSubscriber: Subscriber {
    
    public func receive(subscription: Subscription) {
        self.subscription = subscription
        
        subscription.request(.max(1))
    }
    
    
    public func receive(_ input: Input) -> Subscribers.Demand {
        let shouldContinue = receiveValueAndContinue(input)
        
        isPaused = !shouldContinue
        return isPaused ? .none : .max(1)
    }
    
    
    public func receive(completion: Subscribers.Completion<Failure>) {
        receiveCompletion(completion)
        subscription = nil
    }
}


extension PausableSubscriber: Cancellable {
    
    public func cancel() {
        subscription?.cancel()
        subscription = nil
    }
}


extension PausableSubscriber: Pausable {
    
    public func resume() {
        guard isPaused else { return }
        
        isPaused = false
        
        subscription?.request(.max(1))
    }
}


extension Publisher {
    
    public func pausableSink(
        receiveCompletion: @escaping PausableSubscriber<Output, Failure>.ReceiveCompletion,
        receiveValueAndContinue: @escaping PausableSubscriber<Output, Failure>.ReceiveValueAndContinue,
        subscription: Subscription? = nil,
        isPaused: Bool = false
    ) -> Pausable & Cancellable {
        let subscriber = PausableSubscriber(
            receiveValueAndContinue: receiveValueAndContinue,
            receiveCompletion: receiveCompletion,
            subscription: subscription,
            isPaused: isPaused
        )
        
        subscribe(subscriber)
        
        return subscriber
    }
}


demo(describing: "Using a pausableSink") {

    let subscription = [1, 1, 2, 3, 5, 8, 13, 21]
        .publisher
        .pausableSink(
            receiveCompletion: { completion in
                print("Received completion: \(completion)")
            },
            receiveValueAndContinue: { value in
                print("Received value: \(value)")
                
                if value.isMultiple(of: 3) {
                    print("Pausing")
                    return false
                } else {
                    return true
                }
            }
        )
    
    
    Timer
        .publish(every: 1.0, on: .main, in: .common)
        .autoconnect()
        .sink(
            receiveValue: { _ in
                guard subscription.isPaused else { return }
                print("Resuming subscriber")
                subscription.resume()
            }
        )
        .store(in: &subscriptions)
}

//: [Next](@next)
