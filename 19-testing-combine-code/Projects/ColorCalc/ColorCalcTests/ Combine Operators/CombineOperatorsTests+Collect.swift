//
//  CombineOperatorsTests+Collect.swift
//  ColorCalc
//
//  Created by CypherPoet on 12/20/19.
// ✌️
//

import XCTest
import Combine


extension CombineOperatorsTests {
        
    /// The `collect` operator will buffer values emitted by an upstream publisher,
    /// wait for it to complete, and then emit an array containing those values downstream.
    func testCollect() {
        let basePublisher = PassthroughSubject<Int, Never>()
        let fibs = [1, 1, 2, 3, 5, 8, 13, 21]
        let expectation = XCTestExpectation(description: "Publisher should complete successfully.")
        
        
        basePublisher
            .collect()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        expectation.fulfill()
                    case .failure:
                        XCTFail()
                    }
                },
                receiveValue: { numbers in
                    XCTAssertEqual(numbers, fibs)
                }
            )
            .store(in: &subscriptions)
        
        fibs.forEach { basePublisher.send($0) }
        basePublisher.send(completion: .finished)
        
        wait(for: [expectation], timeout: 2.0)
    }
}
