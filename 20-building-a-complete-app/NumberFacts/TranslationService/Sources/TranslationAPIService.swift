import Foundation
import CypherPoetNetStack


public final class TranslationAPIService {
    public var session: URLSession
    public var apiQueue: DispatchQueue
    
    public init(
        session: URLSession = .shared,
        queue: DispatchQueue = DispatchQueue(label: "TranslationAPIService", qos: .userInitiated)
    ) {
        self.session = session
        self.apiQueue = queue
    }
}


extension TranslationAPIService: TranslationAPIServicing {}
