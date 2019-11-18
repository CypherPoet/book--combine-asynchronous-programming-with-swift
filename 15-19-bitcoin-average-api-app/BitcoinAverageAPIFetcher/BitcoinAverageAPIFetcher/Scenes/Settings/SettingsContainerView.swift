//
//  SettingsContainerView.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/15/19.
// ✌️
//

import SwiftUI


struct SettingsContainerView: View {
    @EnvironmentObject private var store: AppStore
    @State private var isShowingFilterPicker = false
}


// MARK: - Body
extension SettingsContainerView {

    var body: some View {
        NavigationView {
            SettingsView()
                .navigationBarItems(trailing: addFilterButton)
                .sheet(isPresented: $isShowingFilterPicker) {
                    ShitcoinFilterSelectionView()
                        .environmentObject(self.store)
                }
        }
    }
}


// MARK: - Computeds
extension SettingsContainerView {


}


// MARK: - View Variables
extension SettingsContainerView {

    private var addFilterButton: some View {
        Button(action: {
            self.isShowingFilterPicker = true
        }) {
            Text("Add Filter")
        }
    }

}



// MARK: - Preview
struct SettingsContainerView_Previews: PreviewProvider {

    static var previews: some View {
        SettingsContainerView()
            .environmentObject(SampleStore.default)
            .environmentObject(SettingsViewModel(store: SampleStore.default))
    }
}
