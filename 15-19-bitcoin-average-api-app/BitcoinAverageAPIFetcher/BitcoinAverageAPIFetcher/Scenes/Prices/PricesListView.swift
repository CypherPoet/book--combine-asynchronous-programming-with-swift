//
//  PricesListView.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/9/19.
// ✌️
//

import SwiftUI


struct PricesListView: View {
    @ObservedObject private(set) var viewModel: PricesListViewModel
}


// MARK: - Body
extension PricesListView {

    var body: some View {
        VStack {
            Text("\(viewModel.displayedPricesCount) Prices")
        }
    }
}


// MARK: - Computeds
extension PricesListView {


}


// MARK: - View Variables
extension PricesListView {


}



// MARK: - Preview
struct PricesListView_Previews: PreviewProvider {

    static var previews: some View {
        PricesListView(
            viewModel: PricesListViewModel(prices: SamplePrices.default)
        )
    }
}
