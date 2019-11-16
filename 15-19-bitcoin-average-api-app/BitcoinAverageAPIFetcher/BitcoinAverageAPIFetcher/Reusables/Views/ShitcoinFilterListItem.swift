//
//  ShitcoinFilterListItem.swift
//  BitcoinAverageAPIFetcher
//
//  Created by CypherPoet on 11/16/19.
// ✌️
//

import SwiftUI
import SatoshiVSKit


struct ShitcoinFilterListItem: View {
    let shitcoin: Shitcoin
    let isSelected: Bool
    
    let onSelectionToggled: ((Shitcoin, Bool) -> Void)
}


// MARK: - Body
extension ShitcoinFilterListItem {

    var body: some View {
        Button(action: {
            self.onSelectionToggled(self.shitcoin, !self.isSelected)
        }) {
            HStack {
                Text(shitcoin.name)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .imageScale(.large)
                        .foregroundColor(.green)
                        .transition(.opacity)
                }
            }
        }
    }
}


// MARK: - Computeds
extension ShitcoinFilterListItem {
}


// MARK: - View Variables
extension ShitcoinFilterListItem {
}



// MARK: - Preview
struct ShitcoinFilterListItem_Previews: PreviewProvider {

    static var previews: some View {
        ShitcoinFilterListItem(shitcoin: .ada, isSelected: true) { (_, _)  in }
    }
}
