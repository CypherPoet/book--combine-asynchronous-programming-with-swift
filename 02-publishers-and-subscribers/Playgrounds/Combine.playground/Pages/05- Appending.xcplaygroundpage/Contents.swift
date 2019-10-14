//: [Previous](@previous)

import Foundation
import Combine


var subscriptions = Set<AnyCancellable>()


demo(describing: "`append(Output...)`") {
    let numbers = (1...3)
    
    numbers
        .publisher
        .append(4, 5)
        .append([6, 7])
        .append(Set([8, 9]))
        .append(stride(from: -1, through: -5, by: -2))
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


demo(describing: "`append(Output...)` with a PassthroughSubject") {
    let numbers = PassthroughSubject<Int, Never>()
    
    numbers
        .append(4, 5)
        .sink(
            receiveCompletion: { completion in
                print("(sink) Received Completion: \(completion)")
            },
            receiveValue: { value in
                print("(sink) Received Value: \(value)")
            }
        )
        .store(in: &subscriptions)
    
    numbers.send(-4)
    numbers.send(-9)
    
    //: 🔑 Thje upstream must complete or appending would never occur since
    //: Combine couldn’t know the previous publisher has finished emitting all of its elements.
    numbers.send(completion: .finished)
}


demo(describing: "`append(Publisher)`") {
    let positiveStream = [1, 2, 3].publisher
    let negativeStream = [-1, -2, -3].publisher
    
    positiveStream
        .append(negativeStream)
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


demo(describing: "`append(Publisher)` with a PassthroughSubject") {
    let baseStream = [1, 2, 3].publisher
    let otherStream = PassthroughSubject<Int, Never>()
    
    baseStream
        .append(otherStream)
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
    
    //: 🔑 The appended publisher will being emitting values right away
    //: because... why not? Unlike `prepend`, appending is its green light.
}

//: [Next](@next)
