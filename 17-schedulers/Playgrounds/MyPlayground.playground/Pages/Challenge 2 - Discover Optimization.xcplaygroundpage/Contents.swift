//: [Previous](@previous)

import Foundation

import Foundation
import Combine
import SwiftUI
import PlaygroundSupport

//: ## Challenge 2: Discover Optimization
//:
//: Earlier in this chapter, you read about an intriguing question: Is Combine optimizing
//: when you’re using the same scheduler in successive receive(on:) calls, or is
//: it a Dispatch framework optimization?
//:
//: Your challenge is to
//: devise a method that will bring an answer to this question. It’s not very
//: complicated, but it’s not trivial, either.


let incrementer = Timer
    .publish(every: 1.0, on: .main, in: .common)
    .autoconnect()
    .scan(0) { (accumulatedCount, _) in
        accumulatedCount + 1
    }


let targetQueue = DispatchQueue(label: "Target Queue")
let eventQueue = DispatchQueue(label: "Custom Serial Queue", qos: .userInitiated, target: targetQueue)


let setupPublisher = { (recorder: ThreadRecorder) -> AnyPublisher<RecorderData, Never> in
    return incrementer
        .receive(on: eventQueue)
        .recordThread(using: recorder)
        .receive(on: eventQueue)
        .recordThread(using: recorder)
        .eraseToAnyPublisher()
}


//: 🔑 If all values are being received on the same thread -- even when our reception queue is
//:  targeting another queue -- it is most likely to be `Dispatch` that is performing the optimizations.

let recorderView = ThreadRecorderView(title: "Repeating reception with the same Scheduler", setup: setupPublisher)

PlaygroundPage.current.liveView = UIHostingController(rootView: recorderView)



//: [Next](@next)
