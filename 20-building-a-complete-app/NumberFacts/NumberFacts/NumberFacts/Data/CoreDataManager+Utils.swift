//
//  CoreDataManager+Utils.swift
//  NumberFacts
//
//  Created by CypherPoet on 2/18/20.
// ✌️
//

import Foundation
import CypherPoetCoreDataKit_CoreDataManager


extension CoreDataManager {
    static let shared = CoreDataManager(
        managedObjectModelName: "NumberFacts"
    )
}
