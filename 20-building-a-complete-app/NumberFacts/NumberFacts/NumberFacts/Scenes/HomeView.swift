//
//  HomeView.swift
//  NumberFacts
//
//  Created by CypherPoet on 2/19/20.
// ✌️
//

import SwiftUI


struct HomeView {
    enum Tab {
        case numberFactsFeed
        case favoriteNumberFacts
    }
    
    
    @State private var activeTab: Tab = .numberFactsFeed
}


// MARK: - View
extension HomeView: View {

    var body: some View {
        TabView(selection: $activeTab) {
//            FavoriteNumberFactsContainerView()
            
            NumberFactsFeedContainerView()
//            Text("Favorites")
                .tabItem {
                    Image(systemName: "number.circle.fill")
                    Text("Feed")
                }
                .tag(Tab.numberFactsFeed)
            
            
            Text("Favorites")
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
                .tag(Tab.numberFactsFeed)
        }
    }
}


// MARK: - Computeds
extension HomeView {
}


// MARK: - View Variables
extension HomeView {
}


// MARK: - Private Helpers
private extension HomeView {
}



// MARK: - Preview
struct HomeView_Previews: PreviewProvider {

    static var previews: some View {
        HomeView()
    }
}
