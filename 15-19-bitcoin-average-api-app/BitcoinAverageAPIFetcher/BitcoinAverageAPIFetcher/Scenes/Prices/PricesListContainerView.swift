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
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    
    @State private var isShowingSettingsSheet = false
}


// MARK: - Body
extension PricesListContainerView {

    var body: some View {
        NavigationView {
            PricesListView(
                viewModel: PricesListViewModel(store: store)
            )
                .navigationBarTitle("Prices Index")
                .navigationBarItems(trailing: settingsButton)
                .onAppear(perform: fetchPrices)
        }
        .sheet(isPresented: $isShowingSettingsSheet) {
            SettingsContainerView()
                .environmentObject(self.settingsViewModel)
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
                .accessibility(label: Text("View the user settings page."))
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
            .environmentObject(SettingsViewModel(store: SampleStore.default))
    }
    
}
