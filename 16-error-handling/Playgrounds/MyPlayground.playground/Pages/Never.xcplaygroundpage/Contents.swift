//: [Previous](@previous)

import Foundation
import Combine


//: ## Never

var subscriptions = Set<AnyCancellable>()


enum CustomError: Error {
    case ohNo
    case oopsieDaisy
}
    

demo(describing: "Setting a failure type for a `Never` stream") {
    Just("⚡️")
        .setFailureType(to: CustomError.self)
        .eraseToAnyPublisher()
        .sink(
            receiveCompletion: { (completion) in
                switch completion {
                case .failure(.ohNo):
                    print("Oh No!")
                case .failure(.oopsieDaisy):
                    print("Whaaa???!!!")
                case .finished:
                    print("Finished successfully!")
                }
            },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
}

//: [Next](@next)
