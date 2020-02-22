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
   
    func fetchRandomYearFactPayload()
        -> AnyPublisher<NumberFactPayload, NumbersAPIServiceError>
    {
        if let error = error {
            return Fail(outputType: NumberFactPayload.self, failure: error).eraseToAnyPublisher()
        } else {
            return fetchNumberFactPayload(at: Endpoint.NumbersAPI.randomYearFact)
        }
    }
}


final class NumbersAPIServiceTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    private let apiService = MockNumbersAPIService()
}


extension NumbersAPIServiceTests {
    
    func testFetchRandomYearFactPayload() {
        let expectation = XCTestExpectation(description: "Fetch random year fact")

        apiService
            .fetchRandomYearFactPayload()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        expectation.fulfill()
                    case .failure:
                        XCTFail()
                    }
                },
                receiveValue: { numberFactPayload in
                    print("testFetchRandomYearFact :: sink :: Received value: \(numberFactPayload)")
                    XCTAssertEqual(numberFactPayload.category, .year)
                }
            )
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
