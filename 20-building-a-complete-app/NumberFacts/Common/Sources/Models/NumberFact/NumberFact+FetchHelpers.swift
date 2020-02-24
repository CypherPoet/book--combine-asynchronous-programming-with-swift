import Foundation
import CoreData
import CypherPoetCoreDataKit_PredicateUtils


extension NumberFact {
    
    public enum Predicates {
        public static var favorites: NSPredicate {
            let keyword = NSComparisonPredicate.keyword(for: .equalTo)
            
            return NSPredicate(
                format: "%K \(keyword) %@",
                #keyPath(NumberFact.isFavorite),
                NSNumber(booleanLiteral: true)
            )
        }
    }
    
    
    public enum SortDescriptors {
        static let `default`: [NSSortDescriptor] = [
            NSSortDescriptor(keyPath: \NumberFact.number, ascending: true),
        ]
    }
    
    
    public enum FetchRequests {
        
        public static var baseFetchRequest: NSFetchRequest<NumberFact> {
            NSFetchRequest<NumberFact>(entityName: "NumberFact")
        }
        
        
        public static var `default`: NSFetchRequest<NumberFact> {
            let request: NSFetchRequest<NumberFact> = baseFetchRequest
            
            request.sortDescriptors = SortDescriptors.default
            request.predicate = nil
            
            return request
        }
        
        
        public static var favorites: NSFetchRequest<NumberFact> {
            let request: NSFetchRequest<NumberFact> = baseFetchRequest
//            let request: NSFetchRequest<NumberFact> = NSFetchRequest<NumberFact>(entityName: "NumberFact")
            
            request.sortDescriptors = []
            request.predicate = Predicates.favorites
            
            return request
        }
    }
    
}
