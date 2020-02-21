import Foundation
import Combine
import Common
import CypherPoetNetStack
import CoreData


public protocol NumbersAPIServicing {
    typealias NumberFactPayload = (text: String, number: Int, category: NumberFact.Category)
    
    var session: URLSession { get }
    var apiQueue: DispatchQueue { get }
    
    
    func numberFact(
        fromPayload payload: NumberFactPayload,
        in context: NSManagedObjectContext
    ) -> AnyPublisher<NumberFact, Never>
    
    
    func fetchNumberFactPayload(
        at endpoint: Endpoint
    ) -> AnyPublisher<NumberFactPayload, NumbersAPIServiceError>
    
    
    func fetchRandomYearFactPayload() -> AnyPublisher<NumberFactPayload, NumbersAPIServiceError>
    func fetchRandomDateFactPayload() -> AnyPublisher<NumberFactPayload, NumbersAPIServiceError>
    func fetchRandomNumberTriviaPayload() -> AnyPublisher<NumberFactPayload, NumbersAPIServiceError>
    func fetchRandomMathFactPayload() -> AnyPublisher<NumberFactPayload, NumbersAPIServiceError>
}



// MARK: - Default Implementation
extension NumbersAPIServicing {
    
    public func numberFact(
        fromPayload payload: NumberFactPayload,
        in context: NSManagedObjectContext
    ) -> AnyPublisher<NumberFact, Never> {
        let numberFact = NumberFact(context: context)
        
        numberFact.number = Int64(payload.number)
        numberFact.text = payload.text
        numberFact.category = payload.category
        
        return Just(numberFact).eraseToAnyPublisher()
    }
    
    
    public func fetchNumberFactPayload(
        at endpoint: Endpoint
    ) -> AnyPublisher<NumberFactPayload, NumbersAPIServiceError> {
        guard let url = endpoint.url else {
            preconditionFailure("Unable to make url for endpoint")
        }
        
        return session
            .dataTaskPublisher(for: url)
            .receive(on: apiQueue)
            .mapError( { NetStackError.requestFailed(error: $0) })
            .tryMap { (data: Data, response: URLResponse) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetStackError.missingResponse
                }
                
                if case let .failure(error) = NetStackError.parseFrom(data, and: httpResponse) {
                    throw error
                }
                
                guard
                    let number = Int(httpResponse.value(forHTTPHeaderField: "X-Numbers-API-Number") ?? ""),
                    let numberFactCategoryValue = httpResponse.value(forHTTPHeaderField: "X-Numbers-API-Type"),
                    let numberFactCategory = NumberFact.Category(rawValue: numberFactCategoryValue),
                    let numberFactText = String(data: data, encoding: .utf8)
                else {
                    throw NumbersAPIServiceError.parsing(response: httpResponse, data: data)
                }
  
                return (
                    text: numberFactText,
                    number: number,
                    category: numberFactCategory
                )
//                return NumberFact(
//                    number: number,
//                    category: numberFactCategory,
//                    text: numberFactText
//                )
            }
            .mapError { error in
                if let error = error as? NumbersAPIServiceError {
                    return error
                } else if let error = error as? NetStackError {
                    return NumbersAPIServiceError.network(error: error)
                } else {
                    return .generic(error: error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    
    public func fetchRandomYearFactPayload() -> AnyPublisher<NumberFactPayload, NumbersAPIServiceError> {
        fetchNumberFactPayload(at: Endpoint.NumbersAPI.randomYearFact)
    }
    
    public func fetchRandomDateFactPayload() -> AnyPublisher<NumberFactPayload, NumbersAPIServiceError> {
        fetchNumberFactPayload(at: Endpoint.NumbersAPI.randomDateFact)
    }
    
    public func fetchRandomNumberTriviaPayload() -> AnyPublisher<NumberFactPayload, NumbersAPIServiceError> {
        fetchNumberFactPayload(at: Endpoint.NumbersAPI.randomTriviaFact)
    }
    
    public func fetchRandomMathFactPayload() -> AnyPublisher<NumberFactPayload, NumbersAPIServiceError> {
        fetchNumberFactPayload(at: Endpoint.NumbersAPI.randomMathFact)
    }
}

