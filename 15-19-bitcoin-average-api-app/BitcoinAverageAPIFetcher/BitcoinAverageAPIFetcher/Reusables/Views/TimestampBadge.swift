//
//  TimestampBadge.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/11/19.
// ✌️
//

import SwiftUI


struct TimestampBadge: View {
    let timeValue: Date
}


// MARK: - Body
extension TimestampBadge {

    var body: some View {
        Text("\(timeValue, formatter: DateFormatters.priceReadingTimeBadge)")
            .font(.headline)
            .fontWeight(.heavy)
            .padding(10)
            .foregroundColor(.white)
            .background(Color.orange)
            .frame(idealWidth: 100)
            .cornerRadius(8)
    }
}


// MARK: - Computeds
extension TimestampBadge {


}


// MARK: - View Variables
extension TimestampBadge {


}



// MARK: - Preview
struct TimestampBadge_Previews: PreviewProvider {

    static var previews: some View {
        TimestampBadge(timeValue: Date())
    }
}
