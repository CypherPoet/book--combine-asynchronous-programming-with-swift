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
            NumberFact(
                number: 22,
                category: .math,
                text: "408 is the 8^{th} Pell number.",
                currentLanguage: .english,
                translationLanguage: .spanish,
                translatedText: nil
            )
        }()
    }
}
