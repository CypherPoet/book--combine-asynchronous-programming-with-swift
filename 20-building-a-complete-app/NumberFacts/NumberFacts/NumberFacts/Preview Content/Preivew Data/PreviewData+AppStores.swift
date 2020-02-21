//
//  PreviewData+AppStores.swift
//  NumberFacts
//
//  Created by CypherPoet on 2/19/20.
// ✌️
//

import Foundation


extension PreviewData {
    
    enum AppStores {
 
        static let `default`: AppStore = {
            AppStore(
                initialState: AppState(),
                appReducer: appReducer
            )
        }()
    }
}
