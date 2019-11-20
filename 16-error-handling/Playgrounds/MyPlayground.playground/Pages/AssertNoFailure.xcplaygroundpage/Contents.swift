//: [Previous](@previous)

import Foundation
import Combine


//: ## AssertNoFailure

//: The `assertNoFailure` operator is useful when you want to protect
//: yourself during development and confirm a publisher can't finish with a failure event.
//:
//: It doesn't prevent a failure event from being emitted by the upstream.
//: However, it will crash with a fatalError if it detects an error, which
//: gives you a good incentive to fix it in development.


var subscriptions = Set<AnyCancellable>()


enum MyError: Error {
    case oops
}


demo(describing: "assertNoFailure") {
    Just("🚀")
        .setFailureType(to: MyError.self)
//        .tryMap { _ in throw MyError.oops }  // 📝 Uncomment this code to fail
        .assertNoFailure()
        .sink(
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
}

//: [Next](@next)
