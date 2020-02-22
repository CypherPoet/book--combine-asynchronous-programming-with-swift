import Foundation
import CypherPoetNetStack


public enum TranslationAPIServiceError: Error {
    case network(error: NetStackError)
}


extension TranslationAPIServiceError {
    
    public var errorDescription: String? {
        switch self {
        case .network(let error):
            return error.errorDescription
        }
    }
}

// MARK: - Error: Identifiable
extension TranslationAPIServiceError: Identifiable {
    public var id: String? { errorDescription }
}
