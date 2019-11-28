//: [Previous](@previous)

//: ## OperationQueue


import Foundation
import Combine
import PlaygroundSupport
import SwiftUI


var subscriptions = Set<AnyCancellable>()

let computationPublisher = Publishers.ExpensiveComputation(duration: 3)
let startingThreadNumber = Thread.current.number

let incrementer = Timer
    .publish(every: 1.0, on: .main, in: .common)
    .autoconnect()
    .scan(0) { counter, _ in
        counter + 1
    }



//: `OperationQueue` uses the `Dispatch` framework (hence `DispatchQueue`) to execute operations.
//: This means that it doesn‘t guarantee it’ll use the same underlying thread for each delivered value.
//:
//: As such, events have the potential to be received out of order if they're being sent from different threads.
demo(describing: "Using OperationQueue with multiple concurrent tasks") {
    let operationQueue = OperationQueue()

    (1...10)
        .publisher
        .receive(on: operationQueue)
        .sink(
            receiveValue: {
                print("Received value: \($0)")
                print("Current thread: \(Thread.current.number)", terminator: "\n\n")
            }
        )
        .store(in: &subscriptions)
}


//: If we want to control the order in which events are received, we can ensure that they don't run concurrently.
//: So... even if DispatchQueue decided to run it on a different thread, that's cool.
demo(describing: "Using OperationQueue without concurrent tasks") {
    let operationQueue = OperationQueue()
    
    operationQueue.maxConcurrentOperationCount = 1
    
    (1...10)
        .publisher
        .receive(on: operationQueue)
        .sink(
            receiveValue: {
                print("Received value: \($0)")
                print("Current thread: \(Thread.current.number)", terminator: "\n\n")
            }
        )
        .store(in: &subscriptions)
}

//: [Next](@next)
