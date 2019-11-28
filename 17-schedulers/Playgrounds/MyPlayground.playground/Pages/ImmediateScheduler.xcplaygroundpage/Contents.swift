//: [Previous](@previous)

//: ## ImmediateScheduler


import Foundation
import Combine
import PlaygroundSupport
import SwiftUI


var subscriptions = Set<AnyCancellable>()

let computationPublisher = Publishers.ExpensiveComputation(duration: 3)
let customQueue = DispatchQueue(label: "Serial queue")

let startingThreadNumber = Thread.current.number


let incrementer = Timer
    .publish(every: 1.0, on: .main, in: .common)
    .autoconnect()
    .scan(0) { counter, _ in
        counter + 1
    }


//: The `ImmediateScheduler` “schedules” immediately on the current thread.

demo(describing: "ImmediateScheduler") {
    let setupPublisher = { recorder in
        incrementer
            .receive(on: DispatchQueue.global())
            .recordThread(using: recorder)
            .receive(on: ImmediateScheduler.shared)
            //            .receive(on: customQueue)
            .recordThread(using: recorder)
            .eraseToAnyPublisher()
    }

    let view = ThreadRecorderView(title: "Using ImmediateScheduler", setup: setupPublisher)

    PlaygroundPage.current.liveView = UIHostingController(rootView: view)
}

//: [Next](@next)
