//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()



demo(describing: "The `filter` operator") {
    let numbers = (1...20).map { _ in Int.random(in: 1...100) }
    
    numbers.publisher
        .filter({ $0.isMultiple(of: 2) })
        .sink { value in
            print("\(value) is even")
        }
        .store(in: &subscriptions)
}



demo(describing: "The `removeDuplicates` operator") {
    let sentence = "Keep it it secret! Keep Keep it safe!"
    
    sentence
        .components(separatedBy: " ")
        .publisher
        .removeDuplicates()
        .sink { print("(sink) Received value: \($0)") }
        .store(in: &subscriptions)
}

//: [Next](@next)
