import XCTest
import Foundation
import Combine
import Common
import CypherPoetNetStack


@testable import NumbersAPIService


final class MockNumbersAPIService {
    public var session: URLSession
    public var apiQueue: DispatchQueue
    
    var error: NumbersAPIServiceError?
    
    
    public init(
        session: URLSession = .shared,
        queue: DispatchQueue = .init(label: "Test API Queue", qos: .userInitiated),
        error: NumbersAPIServiceError? = nil
    ) {
        self.session = session
        self.apiQueue = queue
        self.error = error
    }
}


extension MockNumbersAPIService: NumbersAPIServicing {
   
    func fetchRandomYearFact(
        using decoder: JSONDecoder = NumberFact.Decoder.default
    ) -> AnyPublisher<NumberFact, NumbersAPIServiceError> {
        if let error = error {
            return Fail(outputType: NumberFact.self, failure: error).eraseToAnyPublisher()
        } else {
            return fetchNumberFact(at: Endpoint.NumbersAPI.randomYearFact, using: decoder)
        }
    }
}


final class NumbersAPIServiceTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    private let apiService = MockNumbersAPIService()
}


extension NumbersAPIServiceTests {
    
    func testFetchRandomYearFact() {
        let expectation = XCTestExpectation(description: "Fetch random year fact")

        apiService
            .fetchRandomYearFact()
            .sink(
                receiveCompletion: { completion in
                    print("testFetchRandomYearFact :: sink :: Received completion: \(completion)")
                    switch completion {
                    case .finished:
                        expectation.fulfill()
                    case .failure:
                        XCTFail()
                    }
                },
                receiveValue: { numberFact in
                    print("testFetchRandomYearFact :: sink :: Received value: \(numberFact)")
                    XCTAssertEqual(numberFact.category, .year)
                }
            )
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
