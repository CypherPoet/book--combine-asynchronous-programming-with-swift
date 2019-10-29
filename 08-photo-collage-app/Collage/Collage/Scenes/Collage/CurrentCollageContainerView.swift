//
//  CurrentCollageContainerView.swift
//  Collage
//
//  Created by CypherPoet on 10/28/19.
// ✌️
//

import SwiftUI


struct CurrentCollageContainerView: View {
//    @EnvironmentObject var collageStore: CollageStore
}


// MARK: - Body
extension CurrentCollageContainerView {

    var body: some View {
        NavigationView {
            CurrentCollageView(
                onSave: saveCollage,
                onClear: clearCollage
            )
        }
    }
}


// MARK: - Private Helpers
extension CurrentCollageContainerView {

    private func saveCollage() {
        
    }
    
    
    private func clearCollage() {
        
    }
}


// MARK: - Preview
struct CurrentCollageContainerView_Previews: PreviewProvider {

    static var previews: some View {
        CurrentCollageContainerView()
    }
}
