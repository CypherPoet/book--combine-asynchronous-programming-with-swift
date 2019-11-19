//
//  PricesListContainerView.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/9/19.
// ✌️
//

import SwiftUI
import SatoshiVSKit


struct PricesListContainerView: View {
    @EnvironmentObject private var store: AppStore
    
    // 📝 NOTE: I'm leaning towards views being resonsible for initializing their own view models
    // during their own `init` function.
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @EnvironmentObject private var pricesListViewModel: PricesListViewModel
    
    @State private var isShowingSettingsSheet = false
}


// MARK: - Body
extension PricesListContainerView {

    var body: some View {
        NavigationView {
            PricesListView(
                viewModel: pricesListViewModel
            )
                .navigationBarTitle("Prices Index")
                .navigationBarItems(trailing: settingsButton)
                .onAppear(perform: fetchPrices)
        }
        .sheet(isPresented: $isShowingSettingsSheet) {
            SettingsContainerView()
                .environmentObject(self.store)
                .environmentObject(self.settingsViewModel)
        }
    }
}


// MARK: - Computeds
extension PricesListContainerView {
    var filteredShitcoins: [Shitcoin] { store.state.settingsState.filteredShitcoins }
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
//        let shitcoins = filteredShitcoins.isEmpty ? Shitcoin.allCases : filteredShitcoins
        let shitcoins: [Shitcoin] = [.link, .ada, .aion]
        
        store.send(PricesSideEffect.fetchLatestIndexPrices(for: shitcoins))
    }
}



// MARK: - Preview
struct PricesListContainerView_Previews: PreviewProvider {

    static var previews: some View {
        PricesListContainerView()
            .environmentObject(SampleStore.default)
            .environmentObject(SettingsViewModel(store: SampleStore.default))
            .environmentObject(PricesListViewModel(store: SampleStore.default))
    }
    
}
