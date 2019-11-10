//: [Previous](@previous)

import Foundation
import Combine


var subscriptions = Set<AnyCancellable>()

let url = URL(string: "https://developer.apple.com/design/human-interface-guidelines")!


demo(describing: "Pitfalls of the `share` operator: being too late with future subscriptions") {
    
    let sharedStream = URLSession.shared
        .dataTaskPublisher(for: url)
        .map(\.data)
        .print("Shared publisher")
        .share()
    
    
    print("Subscribing first...")
    
    sharedStream
        .sink(
            receiveCompletion: { completion in
                print("(subscription 1) - Completion")
            },
            receiveValue: { data in
                print("(subscription 1) Received data: \(data)")
            }
        )
        .store(in: &subscriptions)
    
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        print("Subscribing second...")

        sharedStream
            .sink(
                receiveCompletion: { completion in
                    print("(subscription 2) - Completion")
                },
                receiveValue: { data in
                    print("(subscription 2) Received data: \(data)")
                }
            )
            .store(in: &subscriptions)
    }
}


//: [Next](@next)
