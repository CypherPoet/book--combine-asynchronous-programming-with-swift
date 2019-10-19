//: [Previous](@previous)

/// Challenge: Create a Blackjack card dealer

import Foundation
import Combine

demo(describing: "Challenge: Create a Blackjack card dealer") {
    var subscriptions = Set<AnyCancellable>()
    var dealersDeck = Deck.deckOf52()

    let dealtHand = PassthroughSubject<Hand, HandError>()

    func deal(_ cardCount: Int) {
        var cardsRemaining = dealersDeck.cards.count
        var hand = Hand()
        
        for _ in 0 ..< cardCount {
            let randomIndex = Int.random(in: 0 ..< cardsRemaining)
            hand.append(dealersDeck.cards[randomIndex])
            
            dealersDeck.cards.remove(at: randomIndex)
            cardsRemaining -= 1
            
            if hand.isBusted {
                dealtHand.send(completion: .failure(.busted))
            } else {
                dealtHand.send(hand)
            }
        }
    }
    
    dealtHand
        .sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print(error)
            default:
                print("Hand finished")
            }
        }) { hand in
            print("Current hand: \(hand.cardString), Points: \(hand.points)")
        }
        .store(in: &subscriptions)
    

    deal(3)
}

//: [Next](@next)
