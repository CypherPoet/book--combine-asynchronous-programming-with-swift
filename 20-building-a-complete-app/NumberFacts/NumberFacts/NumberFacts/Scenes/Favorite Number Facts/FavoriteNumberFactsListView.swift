//
//  FavoriteNumberFactsListView.swift
//  NumberFacts
//
//  Created by CypherPoet on 2/23/20.
// ✌️
//

import SwiftUI
import Common


struct FavoriteNumberFactsListView {
    var numberFacts: [NumberFact]
    
    let onFactsDeleted: ((IndexSet) -> Void)?
//    let onLanguageToggled: ((Language) -> Void)?
}


// MARK: - View
extension FavoriteNumberFactsListView: View {

    var body: some View {
        List {
            ForEach(numberFacts) { numberFact in
                Text(numberFact.text)
            }
            .onDelete(perform: onFactsDeleted)
        }
        .navigationBarTitle("Favorite Facts")
    }
}


// MARK: - Computeds
extension FavoriteNumberFactsListView {
}


// MARK: - View Variables
extension FavoriteNumberFactsListView {
}


// MARK: - Private Helpers
private extension FavoriteNumberFactsListView {
}



// MARK: - Preview
struct FavoriteNumberFactsListView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationView {
            FavoriteNumberFactsListView(
                numberFacts: [
                    PreviewData.NumberFacts.sample1,
                ],
                onFactsDeleted: { _ in }
//                onLanguageToggled: { _ in }
            )
        }
    }
}

