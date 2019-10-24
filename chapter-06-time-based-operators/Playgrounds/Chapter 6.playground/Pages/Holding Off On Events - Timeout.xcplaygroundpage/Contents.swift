//: [Previous](@previous)

import Combine
import SwiftUI
import PlaygroundSupport


let timeoutLimit: TimeInterval = 5.0

enum TimeoutError: Error {
    case timedOut
}

// MARK: - Publishers

let basePublisher = PassthroughSubject<Void, TimeoutError>()


// The timedOut subject publisher will time out after X seconds without the
// upstream publisher emitting any value
let timeoutPublisher = basePublisher
    .timeout(
        .seconds(timeoutLimit),
        scheduler: RunLoop.main,
        customError: { .timedOut }
    )



// MARK: - Timelines

let baseTimeline = TimelineView(
    title: "Button Taps",
    events: []
)




// MARK: - View Setup

let view = VStack(spacing: 50) {
    baseTimeline
    
    Button(action: {
        // Send a signal to the base publisher -- which, in turn, will
        // be seen by the `timeoutPublisher`, which is a timeout-modfied version
        // of that publisher wired to stop if a signal isn't sent to the `basePublisher` within
        // the timeout period.
        basePublisher.send()
    }) {
        Text("Tap be within \(timeoutLimit) seconds")
    }
}


PlaygroundPage.current.liveView = UIHostingController(rootView: view)


timeoutPublisher.displayEvents(in: baseTimeline)


//: [Next](@next)
