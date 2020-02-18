import Foundation


public struct NumberFact {
    public var number: Int
    public var category: NumberFact.Category
    public var text: String
    
    public var languageCode: String
    public var translationLanguageCode: String
    
    public var translatedText: String?
    
    
    // MARK: - Init
    public init(
        number: Int,
        category: NumberFact.Category,
        text: String,
        languageCode: String = Locale.current.languageCode ?? "en",
        translationLanguageCode: String = "es",
        translatedText: String? = nil
    ) {
        self.number = number
        self.category = category
        self.text = text
        self.languageCode = languageCode
        self.translationLanguageCode = translationLanguageCode
        self.translatedText = translatedText
    }
}


extension NumberFact {
    public enum Decoder {
        public static let `default` = JSONDecoder()
    }
}
