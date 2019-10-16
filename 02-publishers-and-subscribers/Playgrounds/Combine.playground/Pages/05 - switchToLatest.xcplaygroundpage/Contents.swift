//: [Previous](@previous)

import Foundation
import Combine
import UIKit


var subscriptions = Set<AnyCancellable>()


demo(describing: "`switchToLatest`") {
    typealias NumberStream = PassthroughSubject<Int, Never>
    
    let numberStream1 = NumberStream()
    let numberStream2 = NumberStream()
    let numberStream3 = NumberStream()
    
    let numberStreamContainer = PassthroughSubject<NumberStream, Never>()
    
    numberStreamContainer
        .switchToLatest()
        .sink(
            receiveCompletion: { completion in
                print("(sink) Received Completion: \(completion)")
            },
            receiveValue: { value in
                print("(sink) Received Value: \(value)")
            }
        )
        .store(in: &subscriptions)
    
    
    numberStreamContainer.send(numberStream1)
    numberStream1.send(1)
    numberStream1.send(2)
    numberStreamContainer.send(numberStream2)
    numberStream1.send(99)
    numberStream1.send(100)
    
    numberStream2.send(4)
    numberStream2.send(5)
    numberStreamContainer.send(numberStream3)
    numberStream2.send(99)
    numberStream2.send(100)
    
    numberStream3.send(7)
    numberStream3.send(8)
    numberStream3.send(9)
    
    numberStream3.send(completion: .finished)
    numberStreamContainer.send(completion: .finished)
}



demo(describing: "`switchToLatest` with a network request") {
    
    func getImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared
        .dataTaskPublisher(for: url)
        .map { (data, _) in UIImage(data: data) }
        .print("image")
        .replaceError(with: nil)
        .eraseToAnyPublisher()
    }

    let url = URL(string: "https://source.unsplash.com/random")!
    let tapper = PassthroughSubject<Void, Never>()
        
    
    tapper
        .map { _ in getImage(from: url) }
        .switchToLatest()
        .sink(
            receiveValue: { value in
                if let image = value {
                    image
                }
            }
        )
        .store(in: &subscriptions)
    
    tapper.send()
    
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        tapper.send()
        tapper.send()
        tapper.send()
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
        tapper.send()
    }
}

//: [Next](@next)
