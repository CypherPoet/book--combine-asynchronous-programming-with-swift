import Foundation


public typealias Hand = [PlayingCard]

public extension Hand {
    
    var points: Int {
        reduce(0) { (accumulatedPoints, card) in
            accumulatedPoints + card.points
        }
    }
        
    var cardString: String {
        map { "\($0.rank)\($0.suit)" }.joined(separator: ", ")
    }
    
    var isBusted: Bool { points > 21 }
}
