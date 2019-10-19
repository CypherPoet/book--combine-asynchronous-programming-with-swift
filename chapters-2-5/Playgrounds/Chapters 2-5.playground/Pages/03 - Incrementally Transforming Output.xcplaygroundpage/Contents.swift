//: [Previous](@previous)

import Foundation
import Combine


var subscriptions = Set<AnyCancellable>()



//: `scan` will provide the current value emitted by an upstream
//: publisher to a closure, along with the last value returned by that closure


demo(describing: "The `scan` publisher") {
    let dailyPriceChanges = (0...30).map { _ in Double.random(in: -100...100) }

    dailyPriceChanges.publisher
        .scan(0) { (previousResult, currentValue)  in
            max(0, previousResult + currentValue)
        }
        .sink(receiveValue: { _ in })
        .store(in: &subscriptions)
}


//: [Next](@next)
