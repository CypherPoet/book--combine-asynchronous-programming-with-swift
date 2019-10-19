import Foundation


public enum HandError: Error, CustomStringConvertible {
    case busted
    
    public var description: String {
        switch self {
        case .busted:
            return "Busted!"
        }
    }
}
