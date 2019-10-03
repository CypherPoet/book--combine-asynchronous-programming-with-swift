import Foundation

public struct PlayingCard {
    public let suit: Suit
    public let rank: Rank
    
    
    public init(suit: Suit, rank: Rank) {
        self.suit = suit
        self.rank = rank
    }
}

extension PlayingCard: Equatable {}
extension PlayingCard: Hashable {}


extension PlayingCard: Comparable {
    public static func < (lhs: PlayingCard, rhs: PlayingCard) -> Bool {
        if lhs.rank == rhs.rank {
            // Suit is a tie-breaker when the rank matches
            return lhs.suit < rhs.suit
        } else {
            return lhs.rank < rhs.rank
        }
    }
}
