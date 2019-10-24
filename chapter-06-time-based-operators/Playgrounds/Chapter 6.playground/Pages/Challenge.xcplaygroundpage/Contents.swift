//: [Previous](@previous)

import Foundation
import Combine

//: Challenge:
//:
//: Starting with:
//:
//:     - A subject that emits integers.
//:     - A function call that feeds the subject with mysterious data.
//:
//: Your challenge is to:
//:
//:     - Group data by batches of 0.5 seconds.
//:     - Turn the grouped data into a string.
//:     -  If there is a pause longer than 0.9 seconds in the feed, print the 👏 emoji.
//:     - Print it.
//:
//:
//: Hint: Create a second publisher for this step and merge it
//: with the first publisher in your subscription.
//:
//: Note: To convert an Int to a Character, you can do something like Character(Unicode.Scalar(value)!).
//: If you code this challenge correctly, you’ll see a sentence printed in the Debug area. What is it?



let intStream = PassthroughSubject<Int, Never>()
let collectionInterval: TimeInterval = 0.5

var subscriptions = Set<AnyCancellable>()


let strings = intStream
    .collect(.byTime(
        DispatchQueue.main,
        .seconds(collectionInterval)
    ))
    .map({ numbers in
        String(numbers.map { Character(Unicode.Scalar($0)!) })
    })



let measurements = intStream
    .measureInterval(using: DispatchQueue.main)
    .compactMap({ stride in
        stride > 0.9 ? "👏" : nil
    })


Publishers.Merge(strings, measurements)
    .sink { value in
        print(value)
    }
    .store(in: &subscriptions)
    


feedValues(to: intStream)



//: [Next](@next)
