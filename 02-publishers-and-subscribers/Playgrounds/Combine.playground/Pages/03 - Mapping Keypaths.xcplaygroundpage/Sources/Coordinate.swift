import Foundation
import UIKit


public struct Coordinate {
    public var x: CGFloat
    public var y: CGFloat
    
    
    public init(x: CGFloat = 0, y: CGFloat = 0) {
        self.x = x
        self.y = y
    }
}


extension Coordinate {
    
    public var quadrant: String {
        Self.quadrantDescriptionOf(x: x, y: y)
    }
    
    
    public static func quadrantDescriptionOf(x: CGFloat, y: CGFloat) -> String {
        switch (x, y) {
        case (0, 0):
            return "on the Origin"
        case let (x, _) where x == 0:
            return "on the Y-Axis"
        case let (_, y) where y == 0:
            return "on the X-Axis"
        case let (x, y) where x > 0:
            return "in Quadrant \(y > 0 ? "1" : "4")"
        case let (x, y) where x < 0:
            return "in Quadrant \(y > 0 ? "3" : "3")"
        default:
            fatalError()
        }
    }
}
