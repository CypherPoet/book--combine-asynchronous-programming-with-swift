//
//  PricesListContainerView.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/9/19.
// ✌️
//

import SwiftUI


struct PricesListContainerView: View {
}


// MARK: - Body
extension PricesListContainerView {

    var body: some View {
        NavigationView {
            PricesListView()
                .navigationBarTitle("Prices Index")
        }
    }
}


// MARK: - Computeds
extension PricesListContainerView {


}


// MARK: - View Variables
extension PricesListContainerView {


}



// MARK: - Preview
struct PricesListContainerView_Previews: PreviewProvider {

    static var previews: some View {
        PricesListContainerView()
    }
}
