//
//  DateFormatters.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/11/19.
// ✌️
//

import Foundation


enum DateFormatters {
    static let priceReadingTime: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.timeZone = .current
        formatter.timeStyle = .medium
        
        return formatter
    }()
    
    
    static let priceReadingTimeBadge: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        return formatter
    }()
    
    
    static let priceUpdatedAgo = RelativeDateTimeFormatter()
}
