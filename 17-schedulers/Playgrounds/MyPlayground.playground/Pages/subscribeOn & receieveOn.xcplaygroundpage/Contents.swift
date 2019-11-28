//: [Previous](@previous)

//: ## subscribeOn & receieveOn


import Foundation
import Combine


var subscriptions = Set<AnyCancellable>()

let computationPublisher = Publishers.ExpensiveComputation(duration: 3)
let customQueue = DispatchQueue(label: "Serial queue")

let startingThreadNumber = Thread.current.number



demo(describing: "Directly tapping a stream from the main thread") {
    print("Starting computation on thread \(startingThreadNumber)")

    computationPublisher
        .sink { value in
            let threadNumber = Thread.current.number

            print("Received computation result on thread \(threadNumber): \(value)")
        }
        .store(in: &subscriptions)
}


demo(describing: "Subscribing on a custom scheduler") {
    print("Starting computation on thread \(startingThreadNumber)")
    
    computationPublisher
        .subscribe(on: customQueue)
        .sink { value in
            let threadNumber = Thread.current.number
            
            print("Received computation result on thread \(threadNumber): \(value)")
        }
        .store(in: &subscriptions)
}


demo(describing: "Subscribing on a custom scheduler, then receiving on another scheduler") {
    print("Starting computation on thread \(startingThreadNumber)")
    
    computationPublisher
        .subscribe(on: customQueue)
        .receive(on: DispatchQueue.main)
        .sink { value in
            let threadNumber = Thread.current.number
            
            print("Received computation result on thread \(threadNumber): \(value)")
        }
        .store(in: &subscriptions)
}


//: [Next](@next)
