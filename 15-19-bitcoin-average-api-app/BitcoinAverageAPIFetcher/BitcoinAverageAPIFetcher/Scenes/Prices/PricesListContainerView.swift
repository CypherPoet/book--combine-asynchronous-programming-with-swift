//
//  PricesListContainerView.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/9/19.
// ✌️
//

import SwiftUI


struct PricesListContainerView: View {
    @EnvironmentObject private var store: AppStore
    @State private var isShowingSettingsSheet = false
}


// MARK: - Body
extension PricesListContainerView {

    var body: some View {
        NavigationView {
            PricesListView(
                viewModel: PricesListViewModel(
                    prices: store.state.pricesState.pricesIndexData
                )
            )
                .navigationBarTitle("Prices Index")
                .navigationBarItems(trailing: settingsButton)
                .onAppear(perform: fetchPrices)
        }
        .sheet(isPresented: $isShowingSettingsSheet) {
            SettingsView()
        }
    }
}


// MARK: - Computeds
extension PricesListContainerView {


}


// MARK: - View Variables
extension PricesListContainerView {
    
    private var settingsButton: some View {
        Button(action: {
            self.isShowingSettingsSheet = true
        }, label: {
            Image(systemName: "gear")
                .resizable()
                .imageScale(.large)
        })
    }
}


// MARK: - Private Helpers
private extension PricesListContainerView {

    func fetchPrices() {
        store.send(PricesSideEffect.fetchLatestIndexPrices)
    }
}



// MARK: - Preview
struct PricesListContainerView_Previews: PreviewProvider {

    static var previews: some View {
        PricesListContainerView()
            .environmentObject(SampleStore.default)
    }
}
