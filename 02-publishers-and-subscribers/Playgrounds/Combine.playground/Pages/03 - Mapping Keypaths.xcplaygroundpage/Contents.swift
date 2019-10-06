//: [Previous](@previous)

import Foundation
import Combine


var subscriptions = Set<AnyCancellable>()


demo(describing: "Mapping multiple keypaths") {
    let publisher = PassthroughSubject<Coordinate, Never>()
    
    publisher
        .map(\.x, \.y)
        .sink { (x, y) in
            print("""
                The coordinate at (\(x), \(y)) is \(Coordinate.quadrantDescriptionOf(x: x, y: y))
                """
            )
        }
        .store(in: &subscriptions)
    
    publisher.send(Coordinate(x: 9, y: 10))
    publisher.send(Coordinate(x: 0, y: 10))
    publisher.send(Coordinate(x: -1, y: 10))
    publisher.send(Coordinate(x: 0, y: 0))
    publisher.send(Coordinate(x: 10, y: 0))
}

//: [Next](@next)
