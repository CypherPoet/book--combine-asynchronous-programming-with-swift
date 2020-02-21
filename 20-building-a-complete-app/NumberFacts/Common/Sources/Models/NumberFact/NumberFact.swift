import Foundation


public struct NumberFact {
    public var number: Int
    public var category: NumberFact.Category
    public var text: String
    
    public var currentLanguage: Language
    public var translationLanguage: Language
    
    public var translatedText: String?
    
    
    // MARK: - Init
    public init(
        number: Int,
        category: NumberFact.Category,
        text: String,
        currentLanguage: Language = .english,
        translationLanguage: Language = .spanish,
        translatedText: String? = nil
    ) {
        self.number = number
        self.category = category
        self.text = text
        self.currentLanguage = currentLanguage
        self.translationLanguage = translationLanguage
        self.translatedText = translatedText
    }
}


extension NumberFact {
    public enum Decoder {
        public static let `default` = JSONDecoder()
    }
}
