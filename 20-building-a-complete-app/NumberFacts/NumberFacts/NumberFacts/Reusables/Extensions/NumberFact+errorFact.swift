//
//  NumberFact+errorFact.swift
//  NumberFacts
//
//  Created by CypherPoet on 2/21/20.
// ✌️
//

import Foundation
import Common


extension NumberFact {
    static let errorFact = NumberFact(
        number: -1,
        category: .trivia,
        text: "An error occurred while fetching number facts. Some software uses \"-1\" as a code to represent errors.",
        currentLanguage: .english,
        translationLanguage: .spanish,
        translatedText: nil
    )
}

