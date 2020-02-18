import Foundation
import Combine
import Common


protocol NumbersAPIServicing {
    
    func fetchRandomYearFact(
        using decoder: JSONDecoder
    ) -> AnyPublisher<NumberFact, NumbersAPIServiceError>
        
    
    func fetchRandomDateFact(
        using decoder: JSONDecoder
    ) -> AnyPublisher<NumberFact, NumbersAPIServiceError>
    
    
    func fetchRandomNumberTrivia(
        using decoder: JSONDecoder
    ) -> AnyPublisher<NumberFact, NumbersAPIServiceError>
    
    
    func fetchRandomMathFact(
        using decoder: JSONDecoder
    ) -> AnyPublisher<NumberFact, NumbersAPIServiceError>
}



