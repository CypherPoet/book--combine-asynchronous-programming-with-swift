import Foundation
import CypherPoetNetStack


public enum NumbersAPIServiceError: LocalizedError {
    case network(error: NetStackError)
    case parsing(response: HTTPURLResponse, data: Data)
    case generic(error: Error)
}


extension NumbersAPIServiceError {
    
    public var errorDescription: String? {
        switch self {
        case .network(let error):
            return error.errorDescription
        case .parsing(let response, let data):
            return "Unable to make NumberFact from HTTPURLResponse and Data"
        case .generic:
            return "Unknown error type"
        }
    }
}


// MARK: - Error: Identifiable
extension NumbersAPIServiceError: Identifiable {
    public var id: String? { errorDescription }
}
