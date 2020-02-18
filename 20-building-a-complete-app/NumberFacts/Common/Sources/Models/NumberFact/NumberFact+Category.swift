import Foundation


extension NumberFact {
    
    public enum Category: String {
        case math
        case trivia
        case date
        case year
    }
}


extension NumberFact.Category: CaseIterable {}
extension NumberFact.Category: Identifiable {
    public var id: String { rawValue }
}
