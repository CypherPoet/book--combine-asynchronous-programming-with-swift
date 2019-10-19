//: [Previous](@previous)

//: Several operators, including map, have a counterpart try operator that
//: will take a closure that can throw an error.
//:
//: If you throw an error, it will emit that error downstream.

import Foundation
import Combine


var subscriptions = Set<AnyCancellable>()


demo(describing: "tryMap(_:)") {
    Just("Directory name that does not exist")
        .tryMap { try FileManager.default.contentsOfDirectory(atPath: $0) }
        .sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("(sink) Completed with error: \(error.localizedDescription)")
                case .finished:
                    print("(sink) Successful completion")
                }
            },
            receiveValue: { value in
                print("(sink) Received value: \(value)")
            }
        )
        .store(in: &subscriptions)
}

//: [Next](@next)
