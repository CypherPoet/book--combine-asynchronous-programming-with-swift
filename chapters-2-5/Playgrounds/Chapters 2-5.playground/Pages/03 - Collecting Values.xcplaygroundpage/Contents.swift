//: [Previous](@previous)

import Foundation
import Combine


var cancellables = Set<AnyCancellable>()


demo(describing: "The `collect` operator") {
    let elements = ["🌍", "💨", "🔥", "💦", "🧙‍♂️"]
    
    elements
        .publisher
        .collect()
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
        .store(in: &cancellables)
    
    
    elements
        .publisher
        .collect(2)
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
        .store(in: &cancellables)
    /// The last value is still emitted as an array. That’s because the upstream publisher completed
    /// before collect filled its prescribed buffer, so it sent whatever it had left as an array.
}


//: [Next](@next)
