//: [Previous](@previous)

import Foundation
import Combine
import PlaygroundSupport

//: ## Challenge 1: Stop the Timer
//:
//: In this chapter’s section about DispatchQueue you created a cancellable
//: timer to feed your source publisher with values.
//:
//: Devise two different ways of stopping the timer after 4 seconds.


let incrementer = Timer
    .publish(every: 1.0, on: .main, in: .common)
    .autoconnect()
    .scan(0) { (accumulatedCount, _) in
        accumulatedCount + 1
    }

let eventQueue = DispatchQueue(label: "Custom Serial Queue", qos: .userInitiated)



let numberPublisher = incrementer
    .receive(on: eventQueue)
    .eraseToAnyPublisher()


let subscription = numberPublisher.sink(receiveValue: { print($0) })


// MARK: - Solution 1
//eventQueue.schedule(
//    after: eventQueue.now.advanced(by: .seconds(4)),
//    tolerance: .seconds(0.1)
//) {
//    subscription.cancel()
//}


// MARK: - Solution 2

eventQueue.asyncAfter(deadline: .now() + 4) {
    subscription.cancel()
}

//: [Next](@next)
