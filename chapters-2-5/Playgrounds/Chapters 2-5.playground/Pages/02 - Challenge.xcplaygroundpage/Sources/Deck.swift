import Foundation

public struct Deck {
    public var cards: [PlayingCard]
    
    
    public init(cards: [PlayingCard]) {
        self.cards = cards
    }
    

    public static func deckOf52() -> Deck {
        Deck(cards: makeDeckOf52Cards())
    }
}


extension Deck {
    
    private static func makeDeckOf52Cards() -> [PlayingCard] {
        Suit.allCases.map { suit in
            Rank.allCases.map { rank in
                PlayingCard(suit: suit, rank: rank )
            }
        }
        .flatMap { $0 }
    }
}
