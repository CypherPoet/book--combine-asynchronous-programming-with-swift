import Foundation
import Combine


let samples: [(TimeInterval, Int)] = [
    (0.05, 67),
    (0.10, 111),
    (0.15, 109),
    (0.20, 98),
    (0.25, 105),
    (0.30, 110),
    (0.35, 101),
    (1.50, 105),
    (1.55, 115),
    (2.60, 99),
    (2.65, 111),
    (2.70, 111),
    (2.75, 108),
    (2.80, 33),
]


public func feedValues<S: Subject>(to subject: S) where S.Output == Int {
    var lastDelay: TimeInterval = 0

    for (delay, number) in samples {
        lastDelay = delay
        
        DispatchQueue.main.asyncAfter(deadline: .now() + lastDelay) {
            subject.send(number)
        }
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + lastDelay + 0.5) {
        subject.send(completion: .finished)
    }
}
