//
//  CurrentApplication.swift
//  NumberFacts
//
//  Created by CypherPoet on 2/18/20.
// ✌️
//

import Foundation
import Common
import CypherPoetCoreDataKit_CoreDataManager


struct CurrentApplication {
    var coreDataManager: CoreDataManager
    var defaultLanguage: Language
}


var CurrentApp = CurrentApplication(
    coreDataManager: .shared,
    defaultLanguage: Language(code: Locale.current.languageCode ?? "") ?? .english
)
