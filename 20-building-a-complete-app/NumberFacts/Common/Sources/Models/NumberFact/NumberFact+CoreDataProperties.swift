//
//  NumberFact+CoreDataProperties.swift
//  
//
//  Created by Brian Sipple on 2/21/20.
//
//

import Foundation
import CoreData


extension NumberFact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NumberFact> {
        return NSFetchRequest<NumberFact>(entityName: "NumberFact")
    }

    @NSManaged public var number: Int64
    @NSManaged public var categoryValue: String
    @NSManaged public var text: String
    @NSManaged public var translatedText: String?
    @NSManaged public var currentLanguageValue: String
    @NSManaged public var translationLanguageValue: String
    @NSManaged public var isFavorite: Bool
    
    
    public var category: NumberFact.Category {
        get { NumberFact.Category(rawValue: categoryValue)! }
        set { categoryValue = newValue.rawValue }
    }
    
    
    public var currentLanguage: Language {
        get { Language(rawValue: currentLanguageValue)! }
        set { currentLanguageValue = newValue.rawValue }
    }
    
    
    public var translationLanguage: Language {
        get { Language(rawValue: translationLanguageValue)! }
        set { translationLanguageValue = newValue.rawValue }
    }
}
