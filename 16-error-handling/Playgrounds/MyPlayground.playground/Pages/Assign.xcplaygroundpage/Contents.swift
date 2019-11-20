//: [Previous](@previous)

import Foundation
import Combine


//: ## Assign

var subscriptions = Set<AnyCancellable>()



class Player {
    var name: String = "Unknown"
    var xp: Double = 0.0
}
    


demo(describing: "assign") {
    var player = Player()

    print("Player name before assignment: \(player.name)")
    
    Just("CypherPoet")
//        .setFailureType(to: Error.self)
        .handleEvents(
            receiveCompletion: { _ in print("completion") }
        )
        .assign(to: \.name, on: player)
        .store(in: &subscriptions)
    
    
    print("Player name after assignment: \(player.name)")

}

//: [Next](@next)
