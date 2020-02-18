import XCTest
import Foundation
import Combine


@testable import NumbersAPIService



final class NumbersAPIServiceTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    private let apiService = NumbersAPIService()
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
