//: [Previous](@previous)

import Foundation
import Combine


//: ## try* Operators

var subscriptions = Set<AnyCancellable>()



demo(describing: "tryMap") {
    
    enum NameError: Error {
        case tooShort(String)
        case unknown(error: Error)
    }
    
    
    let namePublisher = PassthroughSubject<String, Never>()
        
    
    namePublisher
        .tryMap { name -> Int in
            guard name.count > 2 else { throw NameError.tooShort(name) }
         
            return name.count
        }
//        .handleEvents(receiveCompletion: { completion in
//            switch completion {
//            case let .failure(NameError.tooShort(name)):
//                print("Finished with Error: \(name) is too short")
//            case let .failure(error):
//                print("Finished with Error: \(error.localizedDescription)")
//            case .finished:
//                print("Finished successfully!")
//            }
//        })
        .eraseToAnyPublisher()
        .mapError({ $0 as? NameError ?? .unknown(error: $0) })
        .sink(
            receiveCompletion: { (completion) in
                switch completion {
                case let .failure(.tooShort(name)):
                    print("Finished with Error: \(name) is too short")
                case let .failure(.unknown(error)):
                    print("Finished with Error: \(error.localizedDescription)")
                case .finished:
                    print("Finished successfully!")
                }
            },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
    

    let names = ["CypherPoet", "V", "Leo"]
//    let names = ["CypherPoet", "Vito", "Leo"]
    
    names.forEach { namePublisher.send($0) }
}

//: [Next](@next)
