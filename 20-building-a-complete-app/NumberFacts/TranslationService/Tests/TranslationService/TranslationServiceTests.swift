import XCTest
import Foundation
import Combine
import Common
import CypherPoetNetStack


@testable import TranslationService


final class MockTranslationAPIService {
    static let translatedText = "Le Texte Traduit"

    
    public var session: URLSession
    public var apiQueue: DispatchQueue
    
    var error: TranslationAPIServiceError?
    
    
    public init(
        session: URLSession = .shared,
        queue: DispatchQueue = .init(label: "Test API Queue", qos: .userInitiated),
        error: TranslationAPIServiceError? = nil
    ) {
        self.session = session
        self.apiQueue = queue
        self.error = error
    }
}


extension MockTranslationAPIService: TranslationAPIServicing {
   
    // 🔑 Comment this method out to hit the API directly
    func fetchTranslation(
        at endpoint: Endpoint,
        using decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<TranslationResponse, TranslationAPIServiceError> {
        if let error = error {
            return Fail(outputType: TranslationResponse.self, failure: error).eraseToAnyPublisher()
        } else {
            return Just(TranslationResponse(text: [Self.translatedText]))
                .setFailureType(to: TranslationAPIServiceError.self)
                .eraseToAnyPublisher()
        }
    }
}


final class TranslationAPIServiceTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    private let apiService = MockTranslationAPIService()
}


extension TranslationAPIServiceTests {
    
    func testFetchTranslationTextForText() {
        let expectation = XCTestExpectation(description: "Fetch translation text for text.")

        apiService
            .fetchTranslationText(
                for: "The Translated Text",
                convertingFrom: .english,
                to: .french
            )
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        expectation.fulfill()
                    case .failure(let error):
                        print(error)
                        XCTFail()
                    }
                },
                receiveValue: { translatedText in
                    XCTAssertEqual(translatedText, MockTranslationAPIService.translatedText)
                }
            )
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
