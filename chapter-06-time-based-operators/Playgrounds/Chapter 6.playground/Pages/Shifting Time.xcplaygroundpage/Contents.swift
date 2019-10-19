//: [Previous](@previous)

import Combine
import SwiftUI
import PlaygroundSupport

//: Creates a publisher that emits one value every second,
//: then delays it by 1.5 seconds and displays both timelines simultaneously
//: to compare them.


let valuesPerSecond = 1.0
let delayInSeconds = 1.5

let basePublisher = PassthroughSubject<Date, Never>()

let delayedPublisher = basePublisher
    .delay(for: .seconds(delayInSeconds), scheduler: DispatchQueue.main)


let subscriber = Timer
    .publish(every: 1.0 / valuesPerSecond, on: .main, in: .common)
    .autoconnect()
    .subscribe(basePublisher)


let baseTimeline = TimelineView(
    title: "Emitted Values (\(valuesPerSecond) per second)",
    events: []
)


let delayedTimeline = TimelineView(
    title: "Delayed Values (delayed by \(delayInSeconds) seconds)",
    events: []
)


let view = VStack(spacing: 50) {
    baseTimeline
    delayedTimeline
}


PlaygroundPage.current.liveView = UIHostingController(rootView: view)


basePublisher.displayEvents(in: baseTimeline)
delayedPublisher.displayEvents(in: delayedTimeline)


//: [Next](@next)

