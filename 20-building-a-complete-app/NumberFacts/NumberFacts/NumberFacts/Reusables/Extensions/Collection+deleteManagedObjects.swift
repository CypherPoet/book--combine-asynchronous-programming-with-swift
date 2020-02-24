//
//  Collection+deleteManagedObjects.swift
//  NumberFacts
//
//  Created by CypherPoet on 2/24/20.
// ✌️
//

import Foundation
import CoreData


extension Collection where
    Element: NSManagedObject,
    Index == Int
{
    
    func delete(at indices: IndexSet) {
        indices.forEach { index in
            let element = self[index]
            
            guard let context = element.managedObjectContext else { preconditionFailure() }
            
            context.delete(element)
        }
        
    }
}
