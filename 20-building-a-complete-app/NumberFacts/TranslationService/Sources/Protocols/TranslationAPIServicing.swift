import Foundation
import Combine
import Common
import CypherPoetNetStack
import CoreData


public struct TranslationResponse {
    var text: [String]
}

extension TranslationResponse: Decodable {}


public protocol TranslationAPIServicing: ModelTransportRequestPublishing {
    var session: URLSession { get }
    var apiQueue: DispatchQueue { get }
    
    
    func fetchTranslationText(
        for text: String,
        convertingFrom sourceLanguage: Language,
        to targetLanguage: Language,
        using decoder: JSONDecoder
    ) -> AnyPublisher<String, TranslationAPIServiceError>
    
    
    func fetchTranslation(
        at endpoint: Endpoint,
        using decoder: JSONDecoder
    ) -> AnyPublisher<TranslationResponse, TranslationAPIServiceError>
}



// MARK: - Default Implementation
extension TranslationAPIServicing {

    public func fetchTranslationText(
        for text: String,
        convertingFrom sourceLanguage: Language,
        to targetLanguage: Language,
        using decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<String, TranslationAPIServiceError> {
        fetchTranslation(
            at: Endpoint.TranslationAPI.translation(
                for: text,
                convertingFrom: sourceLanguage,
                to: targetLanguage
            ),
            using: decoder
        )
        .map(\.text)
        .compactMap { $0.first }
        .eraseToAnyPublisher()
    }

    
    public func fetchTranslation(
        at endpoint: Endpoint,
        using decoder: JSONDecoder
    ) -> AnyPublisher<TranslationResponse, TranslationAPIServiceError> {
        guard let url = endpoint.url else {
             preconditionFailure("Unable to make url for endpoint")
        }
        
        return perform(
            URLRequest(url: url),
            parsingResponseOn: apiQueue,
            with: decoder,
            maxRetries: 1
        )
        .mapError { .network(error: $0) }
        .eraseToAnyPublisher()
    }
}
