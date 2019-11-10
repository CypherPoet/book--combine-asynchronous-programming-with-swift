//: [Previous](@previous)

import Foundation
import Combine


//: The unique characteristic of `multicast(_:)` is that the publisher it returns is a `ConnectablePublisher`.
//:
//: What this means is it won’t subscribe to the upstream publisher until you call its `connect()`.
//:
//: This leaves you ample time to set up all the subscribers you need before letting it connect
//: to the upstream publisher and start the task.



var subscriptions = Set<AnyCancellable>()

let url = URL(string: "https://developer.apple.com/design/human-interface-guidelines")!


demo(describing: "Multicasting") {
    let dataStream = PassthroughSubject<Data, URLError>()
    
    let multicastedTaskPublisher = URLSession.shared
        .dataTaskPublisher(for: url)
        .map(\.data)
        .print("URL task publisher")
        .multicast(subject: dataStream)
        .autoconnect()
        
    
    multicastedTaskPublisher
        .sink(
            receiveCompletion: { completion in
                print("(subscription 1) - Completion")
            },
            receiveValue: { data in
                print("(subscription 1) Received data: \(data)")
            }
        )
        .store(in: &subscriptions)
    
    
    multicastedTaskPublisher
        .sink(
            receiveCompletion: { completion in
                print("(subscription 2) - Completion")
        },
            receiveValue: { data in
                print("(subscription 2) Received data: \(data)")
        }
    )
        .store(in: &subscriptions)
    
    
//    multicastedTaskPublisher.connect()
    
    dataStream.send(Data())
    dataStream.send(Data())
    
}
