import Foundation
import Combine


/// Sample data we use to feed a subject, simulating a user typing "Hello World"
public let typingHelloWorld: [(TimeInterval, String)] = [
    (0.0, "H"),
    (0.1, "He"),
    (0.2, "Hel"),
    (0.3, "Hell"),
    (0.5, "Hello"),
    (0.6, "Hello "),
    (2.0, "Hello W"),
    (2.1, "Hello Wo"),
    (2.2, "Hello Wor"),
    (2.4, "Hello Worl"),
    (2.5, "Hello World")
]


public extension Subject where Output == String {

    /// A function that can feed delayed values to a subject for testing and simulation purposes
    func feed(with data: [(TimeInterval, String)]) {
        var lastDelay: TimeInterval = 0
        
        for (delay, text) in data {
            lastDelay = delay
            
            DispatchQueue.main.asyncAfter(deadline: .now() + lastDelay) { [unowned self] in
                self.send(text)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + lastDelay + 1.5) { [unowned self] in
            self.send(completion: .finished)
        }
    }
}
