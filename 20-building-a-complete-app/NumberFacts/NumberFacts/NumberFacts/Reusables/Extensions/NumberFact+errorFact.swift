//
//  NumberFact+errorFact.swift
//  NumberFacts
//
//  Created by CypherPoet on 2/21/20.
// ✌️
//

import Foundation
import NumbersAPIService
import Common


extension NumberFact {
    static let errorFactPayload: NumbersAPIServicing.NumberFactPayload = (
        text: "An error occurred while fetching number facts. Some software uses \"-1\" as a code to represent errors.",
        number: -1,
        category: .trivia
    )
}
