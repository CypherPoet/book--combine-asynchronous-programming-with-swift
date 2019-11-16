//
//  ShitcoinFilterSelectionView.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/15/19.
// ✌️
//

import SwiftUI
import SatoshiVSKit


struct ShitcoinFilterSelectionView: View {
    @EnvironmentObject var store: AppStore
    @State private var currentCategory: Shitcoin.Category = .fiat
}


// MARK: - Body
extension ShitcoinFilterSelectionView {

    var body: some View {
        List {
            Section {
                Picker("Shitcoin Category", selection: $currentCategory) {
                    ForEach(Shitcoin.Category.allCases) { category in
                        Text(category.rawValue.capitalized).tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.vertical)
            
            
            Section {
                // TODO: Make static, A-Z lists of shitcoins by category
                ForEach(Shitcoin.allCases.filter { $0.category == currentCategory }) { shitcoin in
                    ShitcoinFilterListItem(
                        shitcoin: shitcoin,
                        isSelected: self.currentFilters.contains(shitcoin),
                        onSelectionToggled: self.toggleFilterSelection(_:_:)
                    )
                }
            }
        }
    }
}


// MARK: - Computeds
extension ShitcoinFilterSelectionView {

    var currentFilters: [Shitcoin] {
        store.state.settingsState.filteredShitcoins
    }
}


// MARK: - View Variables
extension ShitcoinFilterSelectionView {
}

// MARK: - Private Helpers
private extension ShitcoinFilterSelectionView {

    func toggleFilterSelection(_ shitcoin: Shitcoin, _ isSelected: Bool) {
        if isSelected {
            store.send(.settings(.add(shitcoinToFilters: shitcoin)))
        } else {
            store.send(.settings(.remove(shitcoinFromFilters: shitcoin)))
        }
    }
}




// MARK: - Preview
struct ShitcoinFilterSelectionView_Previews: PreviewProvider {

    static var previews: some View {
        ShitcoinFilterSelectionView()
            .environmentObject(SampleStore.default)
    }
}
