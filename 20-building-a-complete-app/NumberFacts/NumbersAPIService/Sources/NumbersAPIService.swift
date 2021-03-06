import Foundation
import CypherPoetNetStack


public final class NumbersAPIService {
    public var session: URLSession
    public var apiQueue: DispatchQueue
    
    public init(
        session: URLSession = .shared,
        queue: DispatchQueue = DispatchQueue(label: "NumbersAPIService", qos: .userInitiated)
    ) {
        self.session = session
        self.apiQueue = queue
    }
}


extension NumbersAPIService: NumbersAPIServicing {}
