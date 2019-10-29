//: [Previous](@previous)

import Combine
import SwiftUI
import PlaygroundSupport


var subscriptions = Set<AnyCancellable>()


// MARK: - Publishers

let basePublisher = PassthroughSubject<String, Never>()



let dispatchQueueMeasurementSubject = basePublisher
    .measureInterval(using: DispatchQueue.main)


let runLoopMeasurementSubject = basePublisher
.measureInterval(using: RunLoop.main)



// MARK: - Timelines

let baseTimeline = TimelineView(
    title: "Emitted Values",
    events: []
)


let measurementTimeline = TimelineView(
    title: "Measured Values",
    events: []
)




// MARK: - View Setup

let view = VStack(spacing: 50) {
    baseTimeline
    measurementTimeline
}


PlaygroundPage.current.liveView = UIHostingController(rootView: view)


basePublisher.displayEvents(in: baseTimeline)
dispatchQueueMeasurementSubject.displayEvents(in: measurementTimeline)


// MARK: - 🚀

basePublisher
    .sink { value in
        print("\(deltaTime)s: Base Publisher Emitted: \(value)")
    }
    .store(in: &subscriptions)


dispatchQueueMeasurementSubject
    .sink { value in
        let seconds = Double(value.magnitude) / 1_000_000_000  // convert from nanoseconds
        
        print("\(deltaTime)s: Dispatch Queue Measurement Publisher Emitted: \(seconds)")
    }
    .store(in: &subscriptions)




runLoopMeasurementSubject
    .sink { value in
        print("\(deltaTime)s: Run Loop Measurement Publisher Emitted: \(value)")
    }
    .store(in: &subscriptions)

basePublisher.feed(with: typingHelloWorld)

//: [Next](@next)
