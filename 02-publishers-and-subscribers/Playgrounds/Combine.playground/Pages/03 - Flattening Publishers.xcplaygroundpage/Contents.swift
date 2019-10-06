//: [Previous](@previous)


//: The flatMap operator can be used to flatten multiple upstream publishers into a single
//: downstream publisher — or more specifically, flatten the emissions from those publisher.
//:
//: The publisher returned by flatMap does not — and often will not — be of
//: the same type as the upstream publishers it receives.


//: A common use case for flatMap in Combine is when you want to subscribe to properties
//: of values emitted by a publisher that are themselves publishers

import Foundation
import Combine


var subscriptions = Set<AnyCancellable>()


demo(describing: "Flat Map, Example 1") {
    let helen = Chatter(name: "Helen", message: "[Helen]: Hi, I'm Helen.")
    let paris = Chatter(name: "Paris", message: "[Paris]: Hi, I'm Paris")
    
    let chat = CurrentValueSubject<Chatter, Never>(helen)
    
    chat
        .flatMap(maxPublishers: .max(2)) { $0.message }
        .sink { print($0) }
        .store(in: &subscriptions)
    
    helen.message.value = "[Helen]: How's it going?"

    chat.value = paris
    
    paris.message.value = "Come with me!"
    helen.message.value = "For realz?"
    
    let menelaus = Chatter(name: "Menelaus", message: "[Menelaus]: Helen is mine!")
    
    chat.value = menelaus
    
    paris.message.value = "[Paris]: As long is it won't cause any trouble."
    menelaus.message.value = "[Menelaus]: This is madness!"
    helen.message.value = "[Helen]: Not at all. Let's go!"

    
    //: Menelaus's messages aren't printed, because we've configured `flatMap` with a
    //: max of two publishers
}


//: [Next](@next)
