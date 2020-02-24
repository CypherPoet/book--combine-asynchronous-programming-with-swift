//
//  RootView.swift
//  NumberFacts
//
//  Created by CypherPoet on 2/18/20.
// ✌️
//

import SwiftUI


struct RootView {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject var store: AppStore
}


// MARK: - View
extension RootView: View {

    var body: some View {
        HomeView()
    }
}


// MARK: - Computeds
extension RootView {
}


// MARK: - View Variables
extension RootView {
}


// MARK: - Private Helpers
private extension RootView {
}



// MARK: - Preview
struct RootView_Previews: PreviewProvider {

    static var previews: some View {
        RootView()
            .environmentObject(PreviewData.AppStores.default)
            .environment(\.managedObjectContext, CurrentApp.coreDataManager.mainContext)
    }
}
