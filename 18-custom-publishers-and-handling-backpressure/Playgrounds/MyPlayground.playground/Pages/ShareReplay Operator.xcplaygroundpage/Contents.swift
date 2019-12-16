//: [Previous](@previous)

import Foundation
import Combine


// MARK: - ShareReplaySubscription
extension Publishers {
    
    fileprivate final class ShareReplaySubscription<Output, Failure: Error> {
        
        /// A reference to the subscriber -- kept for the duration of the subscription.
        var subscriber: AnySubscriber<Output, Failure>? = nil
        
        /// Stores pending values in a buffer until they are either delivered to the subscriber or thrown away.
        var buffer: [Output]
        
        /// The replay buffer’s maximum capacity.
        let capacity: Int
        
        /// The potential completion event. This will be delivered to new subscribers as soon as they begin requesting values.
        var completion: Subscribers.Completion<Failure>?
        
        /// The accumulated demand that the publisher receives from the subscriber.
        /// This allows us to deliver exactly the requested number of values.
        var accumulatedDemand: Subscribers.Demand = .none
        
        
        init<S: Subscriber>(
            subscriber: S,
            replayableHistory: [Output],
            capacity: Int,
            completion: Subscribers.Completion<Failure>? = nil
        ) where
            Failure == S.Failure,
            Output == S.Input
        {
            // Store the type-erased version of the subscriber
            self.subscriber = AnySubscriber(subscriber)
            
            self.buffer = replayableHistory
            self.capacity = capacity
            self.completion = completion
        }
    }
}

// MARK: - ShareReplaySubscription Helpers
extension Publishers.ShareReplaySubscription {
    
    /// Relays completion events to the subscriber
    private func complete(with completion: Subscribers.Completion<Failure>) {
        guard let finalSubscriber = subscriber else { return }
        
        // Ensures that any call the subscriber may wrongly issue upon completion will be ignored.
        self.subscriber = nil

        // ensures that the completion is only sent once.
        self.completion = nil
        
        self.buffer.removeAll()
        
        finalSubscriber.receive(completion: completion)
    }
    
    
    /// Emits outstanding events to the subscriber
    private func emitAsNeeded() {
        guard let subscriber = subscriber else { return }
        
        while accumulatedDemand > .none && !buffer.isEmpty {
            accumulatedDemand -= .max(1)
            
            let nextDemand = subscriber.receive(buffer.removeFirst())
            
            // ⚠️ Combine doesn’t treat `Subscribers.Demand.none` as zero -- so adding or
            // subtracting `.none` will trigger an exception.
            if nextDemand != .none {
                self.accumulatedDemand += nextDemand
            }
        }
        
        // If a completion event is pending, send it now.
        if let completion = completion {
            complete(with: completion)
        }
    }
    
    
    func receive(_ input: Output) {
        guard subscriber != nil else { return }
        
        buffer.append(input)
        
        if buffer.count > capacity {
            buffer.removeFirst()
        }
        
        emitAsNeeded()
    }
    
    
    func receive(_ completion: Subscribers.Completion<Failure>) {
        guard let subscriber = subscriber else { return }
        
        self.subscriber = nil
        buffer.removeAll()
        
        subscriber.receive(completion: completion)
    }
}


// MARK: - ShareReplaySubscription: Subscription
extension Publishers.ShareReplaySubscription: Subscription {
    
    func request(_ demand: Subscribers.Demand) {
        if demand != .none {
            accumulatedDemand += demand
        }
        emitAsNeeded()
    }

    
    func cancel() {
        complete(with: .finished)
    }
}


// MARK: - ShareReplay Publisher
extension Publishers {
    
    /// A publisher that...
    ///     - Subscribes to the upstream publisher upon the first subscriber.
    ///     - Replays the last N values to each new subscriber.
    ///     - Relays the completion event, if one emitted beforehand.
    public final class ShareReplay<Upstream: Publisher> {
        public typealias Output = Upstream.Output
        public typealias Failure = Upstream.Failure
        
        private let upstream: Upstream
        private let capacity: Int
        
        /// Because we're going to be feeding multiple subscribers at the
        /// same time, a lock guarantees exclusive access to this publisher's mutable variables.
        private let lock: NSRecursiveLock
        
        private var replayableHistory: [Output]
        private var subscriptions: [ShareReplaySubscription<Output, Failure>]
        private var completion: Subscribers.Completion<Failure>?
        
        
        public init(_ upstream: Upstream, capacity: Int) {
            self.upstream = upstream
            self.capacity = capacity
            
            self.lock = NSRecursiveLock()
            self.replayableHistory = []
            self.subscriptions = []
            self.completion = nil
        }
    }
}


extension Publishers.ShareReplay: Publisher {
    
    private func createSubscription<S>(for subscriber: S)
        where S : Subscriber,
        Failure == S.Failure,
        Output == S.Input
    {
        let subscription = Publishers.ShareReplaySubscription(
            subscriber: subscriber,
            replayableHistory: replayableHistory,
            capacity: capacity,
            completion: completion
        )
        
        subscriptions.append(subscription)
        
        subscriber.receive(subscription: subscription)
    }
    
    
    func connectToUpstreamPublisher() {
        let sink = AnySubscriber(
            receiveSubscription: { subscription in
                // Immediately request `.unlimited` values upon subscription to let the
                // publisher run to completion.
                subscription.request(.unlimited)
            },
            receiveValue: { [weak self] (value: Output) -> Subscribers.Demand in
                self?.relay(value)
                
                return .none
            },
            receiveCompletion: { [weak self] completion in
                self?.complete(completion)
            }
        )
        
        upstream.subscribe(sink)
    }
    
    
    public func receive<S>(subscriber: S)
        where S : Subscriber,
        Failure == S.Failure,
        Output == S.Input
    {
        lock.lock()
        defer { lock.unlock() }
        
        createSubscription(for: subscriber)
        
        guard subscriptions.count == 1 else { return }
        
        connectToUpstreamPublisher()
    }
}


// MARK: - ShareReplay Publisher Helpers
extension Publishers.ShareReplay {
    
    /// Relays incoming values from upstream to each of
    /// the publisher's connected subscribers.
    private func relay(_ value: Output) {
        lock.lock()
        defer { lock.unlock() }
        
        // Only relay values if the upstream publisher hasn't completed yet
        guard completion == nil else { return }
        
        replayableHistory.append(value)
        
        if replayableHistory.count > capacity {
            replayableHistory.removeFirst()
        }

        subscriptions.forEach {
            _ = $0.receive(value)
        }
    }
    
    
    private func complete(_ completion: Subscribers.Completion<Failure>) {
        lock.lock()
        defer { lock.unlock() }
        
        // Save the completion for future subscribers
        self.completion = completion

        subscriptions.forEach {
            _ = $0.receive(completion)
        }
    }
    
}


extension Publisher {
    
    public func shareReplay(capacity: Int = .max) -> Publishers.ShareReplay<Self> {
        .init(self, capacity: capacity)
    }
}


demo(describing: "Using the `shareReplay` publisher") {
    var logger = TimeLogger(sinceOrigin: true)
    let upstreamPublisher = PassthroughSubject<Int, Never>()

    let numberStream = upstreamPublisher
        .print("ShareReplay")
        .shareReplay(capacity: 2)
    
    upstreamPublisher.send(1)
    upstreamPublisher.send(2)
    
    let subscription1 = numberStream
        .sink(
            receiveCompletion: { completion in
                print("(Subscription 1) Receive Completion: \(completion)", to: &logger)
            },
            receiveValue: { number in
                print("(Subscription 1) Receive Value: \(number)", to: &logger)
            }
        )
    
    upstreamPublisher.send(3)
    upstreamPublisher.send(4)
    upstreamPublisher.send(5)
    upstreamPublisher.send(6)
    
    let subscription2 = numberStream
        .sink(
            receiveCompletion: { completion in
                print("(Subscription 2) Receive Completion: \(completion)", to: &logger)
            },
            receiveValue: { number in
                print("(Subscription 2) Receive Value: \(number)", to: &logger)
            }
        )
    
    
    upstreamPublisher.send(7)
    upstreamPublisher.send(8)
    upstreamPublisher.send(completion: .finished)
    
    
    var subscription3: AnyCancellable? = nil
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        print("Subscribing to `shareReplay` after upstream completed")

        subscription3 = numberStream
            .sink(
                receiveCompletion: { completion in
                    print("(Subscription 3) Receive Completion: \(completion)", to: &logger)
                },
                receiveValue: { number in
                    print("(Subscription 3) Receive Value: \(number)", to: &logger)
                }
            )
    }
}


//: [Next](@next)
