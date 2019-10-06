//: [Previous](@previous)

import Foundation
import Combine


var subscriptions = Set<AnyCancellable>()


demo(describing: "`replaceNil`") {
    ["⚡️", "⚡️", nil]
        .publisher
        .replaceNil(with: "💥")
        .sink { print($0) }
        .store(in: &subscriptions)
}


demo(describing: "`replaceNil` and unwrap") {
    ["⚡️", "⚡️", nil]
        .publisher
        .replaceNil(with: "💥")
        .map({ $0! })
        .sink { print($0) }
        .store(in: &subscriptions)
}


demo(describing: "`replaceEmpty`") {
    [].publisher
        .replaceEmpty(with: "🦕")
        .sink(
            receiveCompletion: { completion in
                print(completion)
            },
            receiveValue: { value in
                print(value)
            }
        )
        .store(in: &subscriptions)
    
    
    let empty = Empty<Int, Never>()
    
    empty
        .replaceEmpty(with: 42)
        .sink(
            receiveCompletion: { completion in print(completion) },
            receiveValue: { value in print(value) }
        )
        .store(in: &subscriptions)
}

//: [Next](@next)
