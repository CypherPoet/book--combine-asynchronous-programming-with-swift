//: [Previous](@previous)

//: In addition to collecting values, you’ll often want to transform those values in some way.
//: Combine offers several mapping operators for that purpose

import Foundation
import Combine

var cancellables = Set<AnyCancellable>()


demo(describing: "The `map` operator") {
    let numbers = [1, 1, 2, 3, 5, 8, 13, 21, 34]
    let formatter = NumberFormatter()
    
    formatter.numberStyle = .spellOut
    
    numbers
        .publisher
        .map({ formatter.string(from: $0 as NSNumber) ?? "" })
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
        .store(in: &cancellables)
}


//: [Next](@next)
