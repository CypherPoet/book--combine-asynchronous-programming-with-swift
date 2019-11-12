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
        VStack(alignment: .leading) {
            
            Text("\(viewModel.displayedPricesCount) Prices")
                .font(.headline)
                .padding(.leading)
            
            List {
                Section(header: Text("Filter: All")) {
                    ForEach(viewModel.displayedPrices) { price in
                        VStack(alignment: .leading, spacing: 22) {
                            TimestampBadge(timeValue: price.timestampDate)
                            
                            HStack {
                                Text("\(price.shitcoinSymbol)")
                                Spacer()
                                Text("\(NSDecimalNumber(decimal: price.mostRecent), formatter: NumberFormatters.priceReading)")
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .alert(isPresented: $viewModel.isShowingPricesFetchError, content: { self.pricesFetchAlert })
    }
}



// MARK: - Computeds
extension PricesListView {
}


// MARK: - View Variables
extension PricesListView {
    
    private var pricesFetchAlert: Alert {
        Alert(
            title: Text("An error occurred while attempting to fetch prices"),
            message: Text(viewModel.pricesFetchErrorMessage),
            dismissButton: .default(Text("OK"))
        )
    }
}



// MARK: - Preview
struct PricesListView_Previews: PreviewProvider {

    static var previews: some View {
        PricesListView(
            viewModel: PricesListViewModel(prices: SamplePrices.default)
        )
    }
}
