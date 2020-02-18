import Foundation


public struct NumberFact {
    public var number: Int
    public var category: NumberFact.Category
    public var text: String
    
    
    public init(
        number: Int,
        category: NumberFact.Category,
        text: String
    ) {
        self.number = number
        self.category = category
        self.text = text
    }
    
}


extension NumberFact {
    public enum Decoder {
        public static let `default` = JSONDecoder()
    }
}
