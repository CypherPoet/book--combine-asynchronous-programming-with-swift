//: [Previous](@previous)

import Combine
import SwiftUI
import PlaygroundSupport


let debounceTime: TimeInterval = 1.0



// MARK: - Publishers

let basePublisher = PassthroughSubject<String, Never>()


let debouncedPublisher = basePublisher
    .debounce(for: .seconds(debounceTime), scheduler: DispatchQueue.main)
    // Use `share()` to create a single subscription point to `debounce`
    // that will show the same results at the same time to all subscribers
    .share()



// MARK: - Subscribers

let subscription1 = basePublisher
    .sink { string in
        print("+\(deltaTime)s -- Subject emitted: \(string)")
    }


let subscription2 = debouncedPublisher
    .sink { string in
        print("+\(deltaTime)s -- Subject emitted: \(string)")
    }



// MARK: - Timelines

let baseTimeline = TimelineView(
    title: "Emitted Values",
    events: []
)


let debounceTimeline = TimelineView(
    title: "Debounced Values (debounce time: \(debounceTime) seconds)",
    events: []
)



// MARK: - View Setup

let view = VStack(spacing: 50) {
    baseTimeline
    debounceTimeline
}


PlaygroundPage.current.liveView = UIHostingController(rootView: view)


basePublisher.displayEvents(in: baseTimeline)
debouncedPublisher.displayEvents(in: debounceTimeline)



// 💥

basePublisher.feed(with: typingHelloWorld)


//: [Next](@next)
