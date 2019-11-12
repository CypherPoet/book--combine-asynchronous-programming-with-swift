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
    
    @State private var currentDate = Date()
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
                        VStack(spacing: 8) {
                            
                            Text("\(price.shitcoinSymbol)")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            HStack {
                                Text("\(NSDecimalNumber(decimal: price.mostRecent), formatter: NumberFormatters.priceReading)")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    TimestampBadge(timeValue: price.timestampDate)
                                    
                                    Text(price.updatedAgoText(offsetFrom: self.currentDate))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
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
