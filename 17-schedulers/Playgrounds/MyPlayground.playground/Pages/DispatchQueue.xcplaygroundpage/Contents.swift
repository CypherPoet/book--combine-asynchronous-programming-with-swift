//: [Previous](@previous)

//: ## DispatchQueue


import Foundation
import Combine
import PlaygroundSupport
import SwiftUI


var subscriptions = Set<AnyCancellable>()


let customSerialQueue = DispatchQueue(label: "Serial queue")
let sourceQueue = DispatchQueue.main


// Use this 👇 to see how receive(on:) doesn't appear to
// switch threads when the recption queue is the same as
// the source queue.
//let sourceQueue = customSerialQueue


demo(describing: "DispatchQueue") {
    let sourcePublisher = PassthroughSubject<Void, Never>()
    
    //: While queues are perfectly capable of generating timers, there is no `Publisher` API for queue
    //: timers.
    //:
    //: Instead, we have to use the repeating variant of the `schedule()` method from the `Schedulers` protocol.
    sourceQueue
        .schedule(after: sourceQueue.now, interval: .seconds(1)) {
            sourcePublisher.send()
        }
        .store(in: &subscriptions)
    
    
    let setupPublisher = { recorder in
        sourcePublisher
            .recordThread(using: recorder)
            .receive(
                on: customSerialQueue,
                options: DispatchQueue.SchedulerOptions(
                    qos: .userInteractive
                )
            )
            .recordThread(using: recorder)
            .eraseToAnyPublisher()
    }

    
    let view = ThreadRecorderView(title: "Using DispatchQueue", setup: setupPublisher)

    PlaygroundPage.current.liveView = UIHostingController(rootView: view)
    
}

//: [Next](@next)
