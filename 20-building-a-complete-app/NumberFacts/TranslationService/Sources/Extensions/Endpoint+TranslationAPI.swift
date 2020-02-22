import Foundation
import Common
import CypherPoetNetStack_Core


extension Endpoint {
    
    public enum TranslationAPI {
        private static let apiKey = "trnsl.1.1.20190822T112140Z.d96fa7f4ed58ada0.f7a7297172fb385a6ae2c415b252b0d530e6f495"
        
        private static let scheme = "https"
        private static let host = "translate.yandex.net"
        private static let path = "/api/v1.5/tr.json/translate"

        
        public static func translation(
            for text: String,
            convertingFrom sourceLanguage: Language,
            to targetLanguage: Language
        ) -> Endpoint {
            .init(
                scheme: scheme,
                host: host,
                path: path,
                queryItems: [
                    URLQueryItem(name: "key", value: apiKey),
                    URLQueryItem(name: "text", value: text),
                    URLQueryItem(
                        name: "lang",
                        value: "\(sourceLanguage.code)-\(targetLanguage.code)"
                    ),
                ]
            )
        }
    }
}


