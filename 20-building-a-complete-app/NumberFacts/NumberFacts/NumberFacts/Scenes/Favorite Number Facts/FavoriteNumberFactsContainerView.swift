//
//  FavoriteNumberFactsContainerView.swift
//  NumberFacts
//
//  Created by CypherPoet on 2/23/20.
// ✌️
//

import SwiftUI
import Common
import CoreData



struct FavoriteNumberFactsContainerView {
    @ObservedObject var viewModel: ViewModel
    

    init(
        viewModel: ViewModel = .init()
    ) {
        self.viewModel = viewModel
    }
}


// MARK: - View
extension FavoriteNumberFactsContainerView: View {

    var body: some View {
        NavigationView {
            FavoriteNumberFactsListView(
                numberFacts: viewModel.numberFacts,
                onFactsDeleted: self.deleteNumberFacts(at:)
//                onLanguageToggled: self.toggleLanguage(to:)
            )
            .navigationBarItems(trailing: languageToggleButton)
        }
    }
}


// MARK: - Computeds
extension FavoriteNumberFactsContainerView {
}


// MARK: - View Variables
extension FavoriteNumberFactsContainerView {
    
    private var languageToggleButton: some View {
        Button(action: {
        }) {
            Text("Toggle Language")
        }
    }
}


// MARK: - Private Helpers
private extension FavoriteNumberFactsContainerView {
    
    func toggleLanguage(to language: Language) {
        
    }
    
    
    func deleteNumberFacts(at indices: IndexSet) {
        viewModel.numberFacts.delete(at: indices)
        _ = CurrentApp.coreDataManager.saveContexts()
    }
    
}



// MARK: - Preview
struct FavoriteNumberFactsContainerView_Previews: PreviewProvider {

    static var previews: some View {
        FavoriteNumberFactsContainerView()
    }
}
