//: [Previous](@previous)

import Combine
import SwiftUI
import PlaygroundSupport


let valuesPerSecond = 1.0
let collectionInterval: TimeInterval = 4
let maxCollectionCount = 2

let basePublisher = PassthroughSubject<Date, Never>()


let collectedDatesPublisher1 = basePublisher
    .collect(.byTime(
        DispatchQueue.main,
        .seconds(collectionInterval)
    ))
    .flatMap( { dates in dates.publisher })



let collectedDatesPublisher2 = basePublisher
    .collect(.byTimeOrCount(
        DispatchQueue.main,
        .seconds(maxCollectionCount),
        maxCollectionCount
    ))
    .flatMap( { dates in dates.publisher })



let subscription = Timer
    .publish(every: 1.0 / valuesPerSecond, on: .main, in: .common)
    .autoconnect()
    .subscribe(basePublisher)



let baseTimeline = TimelineView(
    title: "Emitted Values (\(valuesPerSecond) per second)",
    events: []
)


let collectedDatesTimeline1 = TimelineView(
    title: "Collected Values (every \(collectionInterval) seconds)",
    events: []
)


let collectedDatesTimeline2 = TimelineView(
    title: "Collected Values (at most \(maxCollectionCount) every \(collectionInterval) seconds)",
    events: []
)


let view = VStack(spacing: 50) {
    baseTimeline
    collectedDatesTimeline1
    collectedDatesTimeline2
}


PlaygroundPage.current.liveView = UIHostingController(rootView: view)


basePublisher.displayEvents(in: baseTimeline)
collectedDatesPublisher1.displayEvents(in: collectedDatesTimeline1)
collectedDatesPublisher2.displayEvents(in: collectedDatesTimeline2)


//: [Next](@next)
