//: [Previous](@previous)

import Combine
import PlaygroundSupport
import UIKit


extension Notification.Name {
    static let myNotification = Self.init("My Notification")
}

let notificationCenter = NotificationCenter.default


demo(describing: "Traditional Notification Center Observers") {
    let observer = notificationCenter.addObserver(
        forName: .myNotification,
        object: nil,
        queue: nil
    ) { notification in
        print("Received Notification")
    }
    
    notificationCenter.post(name: .myNotification, object: nil)
    notificationCenter.removeObserver(observer)
}


demo(describing: "Subscribing to a Notification Center Publisher") {
    /// Creates a Publisher that emits an event when the notification center broadcasts a notification.
    let publisher = notificationCenter.publisher(for: .myNotification, object: nil)
    
    let subscription = publisher.sink { notification in
        print("Recieved notification from a publisher!")
    }
    
    notificationCenter.post(name: .myNotification, object: nil)
    subscription.cancel()
}


demo(describing: "The \"Just\" publisher") {
    let lightningBolt = Just("⚡️⚡️⚡️⚡️⚡️")

    for _ in (1 ... 5) {
        lightningBolt.sink(
            receiveCompletion: { completion in
                print("Recieved completion: \(completion)")
            },
            receiveValue: { value in
                print("Recieved value: \(value)")
            }
        )
    }
}


demo(describing: "Subscribing with `assign(to:on:)`") {
    // In addition to `sink`, the built-in `assign(to:on:)` operator enables
    // you to assign the received value to a KVO-compliant property on an object.
    
    class Player {
        var name: String {
            didSet { print("Player::name::didSet. New value: \(name)")}
        }
        
        init(name: String) {
            self.name = name
        }
    }
    
    
    let player = Player(name: "Zelda")
    let newName = Just("Link")
    let namesList = ["Snake", "Ezio"]
    
    newName.assign(to: \.name, on: player)
    namesList.publisher.assign(to: \.name, on: player)
}



demo(describing: "Custom Subscriber") {
    let publisher = (1 ... 6).publisher
    let subscriber = IntSubscriber()
    
    publisher.subscribe(subscriber)
}


var subscriptions: Set<AnyCancellable> = []

demo(describing: "The \"Future\" Publisher") {
    
    func increment(
        _ integer: Int,
        afterDelay delay: TimeInterval,
        on queue: DispatchQueue = .global()
    ) -> Future<Int, Never> {
        Future<Int, Never> { promise in
            queue.asyncAfter(deadline: .now() + delay) {
                promise(.success(integer + 1))
            }
        }
    }
    
    let numbers = [1, 1, 2, 3, 5]
    
    for number in numbers {
        let future = increment(number, afterDelay: 1)
        
        future
            .sink(
                receiveCompletion: { completion in
                    print("Increment \(number) -- received completion: \(completion)")
                },
                receiveValue: { value in
                    print("Increment \(number) -- received value: \(value)")
                }
            )
            .store(in: &subscriptions)
    }
}



//: [Next](@next)
