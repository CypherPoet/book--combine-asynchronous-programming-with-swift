//: [Previous](@previous)

import Foundation
import Combine


var subscriptions = Set<AnyCancellable>()


demo(describing: "`prepend(Output...)`") {
    let numbers = (7...8)
    
    numbers
        .publisher
        // The order of operations is important here: The nature of `prepend` means
        // that later operators will add their values to the BEGINNING of the existing
        // values in the stream
        .prepend(1, 2)
        .prepend([3, 4])
        .prepend(Set([5, 6]))
        .prepend(stride(from: -1, through: -5, by: -2))
        .sink(
            receiveCompletion: { completion in
                print("(sink) Received Completion: \(completion)")
            },
            receiveValue: { value in
                print("(sink) Received Value: \(value)")
            }
        )
        .store(in: &subscriptions)
}


demo(describing: "`prepend(Publisher)`") {
    let positiveStream = [1, 2, 3].publisher
    let negativeStream = [-1, -2, -3].publisher
    
    positiveStream
        .prepend(negativeStream)
        .sink(
            receiveCompletion: { completion in
                print("(sink) Received Completion: \(completion)")
            },
            receiveValue: { value in
                print("(sink) Received Value: \(value)")
            }
        )
        .store(in: &subscriptions)
}


demo(describing: "`prepend(Publisher)` with a PassthroughSubject") {
    let baseStream = [1, 2, 3].publisher
    let otherStream = PassthroughSubject<Int, Never>()
    
    baseStream
        .prepend(otherStream)
        .sink(
            receiveCompletion: { completion in
                print("(sink) Received Completion: \(completion)")
            },
            receiveValue: { value in
                print("(sink) Received Value: \(value)")
            }
        )
        .store(in: &subscriptions)
    
    
    otherStream.send(99)
    otherStream.send(124)
    otherStream.send(-12)
    
    
    // the `baseStream` publisher won't emit values until it
    // knows that the prepended publisher has completed
    otherStream.send(completion: .finished)
}



//: [Next](@next)
