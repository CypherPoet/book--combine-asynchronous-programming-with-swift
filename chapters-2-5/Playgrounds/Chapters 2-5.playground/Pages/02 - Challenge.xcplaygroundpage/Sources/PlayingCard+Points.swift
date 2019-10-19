import Foundation


extension PlayingCard {
    
    public var points: Int {
        switch self.rank {
        case .jack,
             .queen,
             .king:
            return 10
        case .ace:
            return 11
        default:
            return self.rank.rawValue
        }
    }
}
