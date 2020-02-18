import Foundation
import CypherPoetNetStack_Core


extension Endpoint {
    
    public enum NumbersAPI {
        private static let host = "numbersapi.com"
        
        
        public static var randomYearFact: Endpoint {
            .init(
                scheme: "http",
                host: host,
                path: "/random/year"
            )
        }
        
        
        public static var randomDateFact: Endpoint {
            .init(
                scheme: "http",
                host: host,
                path: "/random/date"
            )
        }
        
        
        public static var randomTriviaFact: Endpoint {
            .init(
                scheme: "http",
                host: host,
                path: "/random/trivia"
            )
        }
        
        
        public static var randomMathFact: Endpoint {
            .init(
                scheme: "http",
                host: host,
                path: "/random/math"
            )
        }
    }
}


