//
//  CombineOperatorsTests+FlatMap.swift
//  ColorCalc
//
//  Created by CypherPoet on 12/20/19.
// ✌️
//

import XCTest
import Combine


extension CombineOperatorsTests {
        
    func testFlatMapWithTwoMaxPublishers() {
        typealias EventSource = PassthroughSubject<Int, Never>
       
        let basePublisher1 = EventSource()
        let basePublisher2 = EventSource()
        let basePublisher3 = EventSource()
        
        let numberStream = CurrentValueSubject<EventSource, Never>(basePublisher1)
        
        let fibs = [1, 1, 2, 3, 5, 8, 13, 21]
        let eventCount = 4
//        let expectation = XCTestExpectation(description: "Publisher should complete successfully.")
        let expectedValues = Array(fibs.prefix(upTo: eventCount))
        
        var receivedValues: [Int] = []
        
//        let receiveCompletion: ((Subscribers.Completion<EventSource.Failure>) -> Void) =  { completion in
//            switch completion {
//            case .finished:
//                XCTAssertEqual(receivedValues, expectedValues)
//                expectation.fulfill()
//            case .failure:
//                XCTFail()
//            }
//        }
        
        numberStream
            .flatMap(maxPublishers: .max(2), { subject in
                subject
            })
            .sink(
//                receiveCompletion: receiveCompletion,
                receiveValue: { number in
                    receivedValues.append(number)
                }
            )
            .store(in: &subscriptions)

        
        basePublisher1.send(expectedValues[0])
        
        numberStream.send(basePublisher2)
        
        basePublisher2.send(expectedValues[1])
        basePublisher2.send(expectedValues[2])
        basePublisher2.send(expectedValues[3])
        

        // Send values after max publishers have been used
        numberStream.send(basePublisher3)
        
        basePublisher3.send(-expectedValues[1])
        basePublisher3.send(-expectedValues[2])
        basePublisher3.send(-expectedValues[3])


        numberStream.send(completion: .finished)
        XCTAssertEqual(receivedValues, expectedValues)

        // TOOD: 🤔 Not sure why this hangs
        //        wait(for: [expectation], timeout: 3.0)
    }
}
