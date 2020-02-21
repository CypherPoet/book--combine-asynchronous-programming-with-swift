//
//  PreviewData+NumberFacts.swift
//  NumberFacts
//
//  Created by CypherPoet on 2/20/20.
// ✌️
//

import Foundation
import Common


extension PreviewData {
    
    enum NumberFacts {
        
        static let sample1: NumberFact = {
            let context = CurrentApp.coreDataManager.mainContext
            let numberFact = NumberFact(context: context)
                
            numberFact.number = 22
            numberFact.category = .math
            numberFact.text = "408 is the 8^{th} Pell number."
            numberFact.currentLanguage = .english
            numberFact.translationLanguage = .spanish
            numberFact.translatedText =  nil
            numberFact.isFavorite = false
            
            return numberFact
        }()
    }
}
