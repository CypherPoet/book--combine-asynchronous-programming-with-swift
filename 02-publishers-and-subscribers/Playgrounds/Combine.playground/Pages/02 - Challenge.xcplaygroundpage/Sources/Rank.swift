import Foundation

public enum Rank: Int, CaseIterable {
    case two = 2
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    
    case jack
    case queen
    case king
    case ace
}



// MARK: - Comparable
extension Rank: Comparable {
    public static func < (lhs: Rank, rhs: Rank) -> Bool {
        switch (lhs, rhs) {
        case (_, _) where lhs == rhs:
            return false
        case (.ace, _):
            return false
        case (_, _):
            return lhs.rawValue < rhs.rawValue
        }
    }
}



// MARK: - CustomStringConvertible
extension Rank: CustomStringConvertible {
    public var description: String {
        switch self {
        case .ace: return "A"
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        default:
            return "\(rawValue)"
        }
    }
}
