//
//  NumberFactCardView.swift
//  NumberFacts
//
//  Created by CypherPoet on 2/20/20.
// ✌️
//

import SwiftUI
import Common


struct NumberFactCardView {
    var viewModel: ViewModel
    
    let onFactLiked: ((NumberFact) -> Void)
    let onFactDisliked: ((NumberFact) -> Void)
}


// MARK: - View
extension NumberFactCardView: View {

    var body: some View {
        Rectangle()
            .fill(Color(UIColor.secondarySystemBackground))
            .frame(width: 300, height: 500)
            .overlay(
                Text(viewModel.numberFact.text)
            )
            .shadow(color: .gray, radius: 12, x: 0, y: 0)
    }
}


// MARK: - Computeds
extension NumberFactCardView {
}


// MARK: - View Variables
extension NumberFactCardView {
}


// MARK: - Private Helpers
private extension NumberFactCardView {
}



// MARK: - Preview
struct NumberFactCardView_Previews: PreviewProvider {

    static var previews: some View {
        NumberFactCardView(
            viewModel: .init(
                numberFact: PreviewData.NumberFacts.sample1,
                language: CurrentApp.defaultLanguage
            ),
            onFactLiked: { _ in },
            onFactDisliked: { _ in }
        )
    }
}
