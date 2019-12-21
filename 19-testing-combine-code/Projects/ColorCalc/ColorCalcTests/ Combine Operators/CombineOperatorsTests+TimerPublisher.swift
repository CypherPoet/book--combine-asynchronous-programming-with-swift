//
//  CombineOperatorsTests+TimerPublisher.swift
//  ColorCalc
//
//  Created by CypherPoet on 12/21/19.
// ✌️
//

import XCTest
import Combine


fileprivate extension TimeInterval {
    
    var normalized: TimeInterval {
        (self * 10).rounded() / 10
    }
    
}


extension CombineOperatorsTests {
        
    
    /// The `collect` operator will buffer values emitted by an upstream publisher,
    /// wait for it to complete, and then emit an array containing those values downstream.
    func testTimerPublish() {
        let timer = Timer
            .publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .prefix(3)

        let expectation = XCTestExpectation(description: #function)
        let expectedTimeIntervals = [0.5, 1, 1.5]
        var receivedTimeIntervals: [TimeInterval] = []
        
        let startTimeInterval = Date.timeIntervalSinceReferenceDate
        
        timer
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
//                        XCTAssertEqual(receivedTimeIntervals, expectedTimeIntervals)
                        expectation.fulfill()
                    case .failure:
                        XCTFail()
                    }
                },
                receiveValue: { date in
                    let interval = (date.timeIntervalSinceReferenceDate - startTimeInterval)
                    
                    receivedTimeIntervals.append(interval.normalized)
                }
            )
            .store(in: &subscriptions)
        
        
        XCTAssertEqual(receivedTimeIntervals, expectedTimeIntervals)
        wait(for: [expectation], timeout: 2.0)

    }
}
