//: [Previous](@previous)

//: ## RunLoop Scheduling


import Foundation
import Combine
import PlaygroundSupport
import SwiftUI


var subscriptions = Set<AnyCancellable>()

let customQueue = DispatchQueue(label: "Serial queue")


let incrementer = Timer
    .publish(every: 1.0, on: .main, in: .common)
    .autoconnect()
    .scan(0) { counter, _ in
        counter + 1
}


//demo(describing: "Receiving Events with RunLoop") {
//    let setupPublisher = { recorder in
//        incrementer
//            .receive(on: DispatchQueue.global())
//            .recordThread(using: recorder)
//            .receive(on: RunLoop.current)
//            .recordThread(using: recorder)
//            .eraseToAnyPublisher()
//    }
//
//    let view = ThreadRecorderView(title: "RunLoop Scheduling", setup: setupPublisher)
//
//    PlaygroundPage.current.liveView = UIHostingController(rootView: view)
//}


var threadRecorder: ThreadRecorder?


demo(describing: "Scheduling Execution with RunLoop") {
//    let setupPublisher = { (recorder: ThreadRecorder) -> AnyPublisher<RecorderData, Never> in
//        threadRecorder = recorder
//
//        return incrementer
//            .receive(on: DispatchQueue.global())
//            .recordThread(using: recorder)
//            .receive(on: RunLoop.current)
//            .recordThread(using: recorder)
//            .eraseToAnyPublisher()
//    }


    let setupPublisher = { recorder in
        incrementer
            .receive(on: DispatchQueue.global())
            .recordThread(using: recorder)
            .receive(on: RunLoop.current)
            .recordThread(using: recorder)
            .handleEvents(
                receiveSubscription: { _ in
                    threadRecorder = recorder
                }
            )
            .eraseToAnyPublisher()
    }
    
    
    RunLoop.current.schedule(
        after: .init(Date(timeIntervalSinceNow: 4.5)),
        tolerance: .milliseconds(500)
    ) {
        threadRecorder?.subscription?.cancel()
    }
    
    
    let view = ThreadRecorderView(title: "Scheduling Execution with RunLoop", setup: setupPublisher)

    PlaygroundPage.current.liveView = UIHostingController(rootView: view)
}

//: [Next](@next)
