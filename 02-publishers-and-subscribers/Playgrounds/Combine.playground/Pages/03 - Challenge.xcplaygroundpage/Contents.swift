//: [Previous](@previous)

//: 🥅 Challenge: Create a phone number lookup using transforming operators

import Foundation
import Combine


var subscribers = Set<AnyCancellable>()


demo(
    describing: "Challenge: Creating a phone number lookup using transforming operators"
) {
    let inputReceiver = PassthroughSubject<Character, Never>()
    
    inputReceiver
        .map(Phone.numberFromInput)
        .replaceNil(with: 0)
        .collect(10)
        .map { digits in
            digits.reduce("", { (digitString, currentDigit) in
                "\(digitString)\(currentDigit)"
            })
        }
        .map(PhoneBook.formattedPhoneNumber(from:))
        .print()
        .map(PhoneBook.dial(phoneNumber:))
        .sink(
            receiveCompletion: { completion in
                print("(sink) Received completion: \(completion)")
            },
            receiveValue: { value in
                print("(sink) Received value: \(value)")
            }
        )
        .store(in: &subscribers)
    
    
    "0123456789".forEach { inputReceiver.send($0) }
    "7777777777".forEach { inputReceiver.send($0) }
    "✌️🙂🍁🦅3🙂🍁🦅✌️🙂".forEach { inputReceiver.send($0) }
}



//: [Next](@next)
