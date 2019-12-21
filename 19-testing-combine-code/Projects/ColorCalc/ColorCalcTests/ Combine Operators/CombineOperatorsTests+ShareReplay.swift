//
//  CombineOperatorsTests+ShareReplay.swift
//  ColorCalc
//
//  Created by CypherPoet on 12/21/19.
// ✌️
//

import XCTest
import Combine
import CypherPoetCombineKit_ShareReplay


extension CombineOperatorsTests {
        
    func testShareReplay() {
        let basePublisher = PassthroughSubject<Int, Never>()
        let numberStream = basePublisher.shareReplay(capacity: 2)
        
        let expectation = XCTestExpectation(description: "Publisher should complete successfully.")
        let expectedValues = [1, 2, 3, 4, 3, 4, 5, 5]
        var receivedValues: [Int] = []
        
        
        numberStream
            .sink(receiveValue: { receivedValues.append($0) })
            .store(in: &subscriptions)

        
        basePublisher.send(1)
        basePublisher.send(2)
        basePublisher.send(3)
        basePublisher.send(4)
        
        
        numberStream
            .sink(receiveValue: { receivedValues.append($0) })
            .store(in: &subscriptions)
        
        
        basePublisher.send(5)
        
        XCTAssertEqual(receivedValues, expectedValues)
    }
}
