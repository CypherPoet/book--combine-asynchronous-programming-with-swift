import UIKit
import Combine


extension Notification.Name {
    static let myNotification = Self.init("My Notification")
}

let notificationCenter = NotificationCenter.default

var subscriptions = Set<AnyCancellable>()


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


demo(describing: "Publishers and Subscribers") {
    /// Creates a Publisher that emits an event when the notification center broadcasts a notification.
    let publisher = notificationCenter.publisher(for: .myNotification, object: nil)
    
    let subscription = publisher.sink { notification in
        print("Recieved notification from a publisher!")
    }
    
    notificationCenter.post(name: .myNotification, object: nil)
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
