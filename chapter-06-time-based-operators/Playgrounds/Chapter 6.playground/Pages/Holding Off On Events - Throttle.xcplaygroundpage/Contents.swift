//: [Previous](@previous)

import Combine
import SwiftUI
import PlaygroundSupport


//: The fundamental difference between debounce and throttle:
//:
//:     - Debounce waits for a pause in values it receives,
//:       then emits the latest one after the specified interval.
//:
//:
//:     - Throttle waits for the specified interval, then emits either
//:       the first or the latest of the values it received during that interval.
//:       It doesn’t care about pauses.
//:

let throttleDelay: TimeInterval = 1.0



// MARK: - Publishers

let basePublisher = PassthroughSubject<String, Never>()


let throttledPublisher = basePublisher
    .throttle(for: .seconds(throttleDelay), scheduler: DispatchQueue.main, latest: false)
    // Use `share()` to create a single subscription point to `debounce`
    // that will show the same results at the same time to all subscribers
    .share()



// MARK: - Subscribers

let subscription1 = basePublisher
    .sink { string in
        print("+\(deltaTime)s -- Base Subject emitted: \(string)")
    }


let subscription2 = throttledPublisher
    .sink { string in
        print("+\(deltaTime)s -- Throttled Subject emitted: \(string)")
    }



// MARK: - Timelines

let baseTimeline = TimelineView(
    title: "Emitted Values",
    events: []
)


let throttleTimeline = TimelineView(
    title: "Throttled Values (throttle delay: \(throttleDelay) seconds)",
    events: []
)



// MARK: - View Setup

let view = VStack(spacing: 50) {
    baseTimeline
    throttleTimeline
}


PlaygroundPage.current.liveView = UIHostingController(rootView: view)


basePublisher.displayEvents(in: baseTimeline)
throttledPublisher.displayEvents(in: throttleTimeline)



// 💥

basePublisher.feed(with: typingHelloWorld)


//: [Next](@next)
