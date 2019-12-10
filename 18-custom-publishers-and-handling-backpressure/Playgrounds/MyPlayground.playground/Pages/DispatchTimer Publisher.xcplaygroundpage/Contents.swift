//: [Previous](@previous)

import Foundation
import Combine

//: Implementing a type in the `Publishers` namespace with a Subscription that produces values.


var subscriptions = Set<AnyCancellable>()


struct DispatchTimerConfiguration {
    
    /// A specific queue for the timer to fire on.  This is
    /// optional for when we  don’t care.
    let queue: DispatchQueue?
    
    /// The interval at which the timer will fire, starting from the subscription time.
    let interval: DispatchTimeInterval
    
    /// The maximum amount of time after the deadline
    /// that the system may delay the delivery of the timer event.
    let leeway: DispatchTimeInterval
    
    
    /// The desired number of timer events to receive.
    /// We want the flexibility of configurng a limited number of events before completing.
    let eventLimit: Subscribers.Demand
}


extension Publishers {

    private final class DispatchTimerSubscription<S: Subscriber>: Subscription
        where S.Input == DispatchTime
    {
        let configuration: DispatchTimerConfiguration
        
        var subscriber: S?
        var remainingEventCapacity: Subscribers.Demand
        var currentDemand: Subscribers.Demand = .none
        var eventSource: DispatchSourceTimer? = nil
        
        
        init(
            subscriber: S,
            configuration: DispatchTimerConfiguration
        ) {
            self.subscriber = subscriber
            self.configuration = configuration
            self.remainingEventCapacity = configuration.eventLimit
        }
        
        
        // Called by a subscriber requesting a value
        func request(_ demand: Subscribers.Demand) {
            guard remainingEventCapacity > .none else {
                subscriber?.receive(completion: .finished)
                return
            }

            currentDemand += demand
            
            // If the timer doesn't exist yet, and we have demand, that's our cue.
            if eventSource == nil, currentDemand > .none {
                setupEventSource()
            }
        }
        
        
        func cancel() {
            // 🔑 Setting the `DispatchSourceTimer` to nil is enough to stop it from running.
            // Setting the subscriber property to nil releases it from the subscription’s reach.
            eventSource = nil
            subscriber = nil
        }
        
        
        func setupEventSource() {
            let source = DispatchSource.makeTimerSource(queue: configuration.queue)
            
            source.schedule(
                deadline: .now() + configuration.interval,
                repeating: configuration.interval,
                leeway: configuration.leeway
            )
            
            
            source.setEventHandler { [weak self] in
                guard
                    let self = self,
                    self.currentDemand > .none
                else { return }
                
                self.currentDemand -= .max(1)
                self.remainingEventCapacity -= .max(1)
                
                _ = self.subscriber?.receive(.now())
                
                if self.remainingEventCapacity == .none {
                    self.subscriber?.receive(completion: .finished)
                }
            }
            
            self.eventSource = source
            source.activate()
        }
    }

}


extension Publishers {
    
    struct DispatchTimer: Publisher {
        typealias Output = DispatchTime
        typealias Failure = Never
        
        
        let configuration: DispatchTimerConfiguration
        
        
        init(configuration: DispatchTimerConfiguration) {
            self.configuration = configuration
        }
        
        
        func receive<S: Subscriber>(subscriber: S)
            where Failure == S.Failure,
                Output == S.Input
        {
            let subscription = DispatchTimerSubscription(
                subscriber: subscriber,
                configuration: configuration
            )
            
            subscriber.receive(subscription: subscription)
        }
    }
}


extension Publishers {
    
    // An operator that allows us to chain our custom publisher
    static func timer(
        queue: DispatchQueue? = nil,
        interval: DispatchTimeInterval,
        leeway: DispatchTimeInterval = .nanoseconds(0),
        eventLimit: Subscribers.Demand = .unlimited
    ) -> Publishers.DispatchTimer {
        .init(
            configuration: DispatchTimerConfiguration(
                queue: queue,
                interval: interval,
                leeway: leeway,
                eventLimit: eventLimit
            )
        )
    }
}


demo(describing: "Logging events emiited by our `DispatchTimer` publisher") {
    var logger = TimeLogger(sinceOrigin: true)
    let publisher = Publishers.timer(interval: .seconds(1), eventLimit: .max(6))

    publisher
        .sink(receiveCompletion: { completion in
            print("DispatchTimer sink 1, received completion: \(completion)", to: &logger)
        }, receiveValue: { value in
            print("DispatchTimer sink 1, received value: \(value)", to: &logger)
        })
        .store(in: &subscriptions)
}



demo(describing: "Manually cancelling the custom timer") {
    var logger = TimeLogger(sinceOrigin: true)
    let publisher = Publishers.timer(interval: .seconds(1), eventLimit: .max(6))

    let subscription = publisher
        .sink(receiveCompletion: { completion in
            print("DispatchTimer sink 2, received completion: \(completion)", to: &logger)
        }, receiveValue: { value in
            print("DispatchTimer sink 2, received value: \(value)", to: &logger)
        })

    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
        subscription.cancel()
    }
}





//: [Next](@next)
