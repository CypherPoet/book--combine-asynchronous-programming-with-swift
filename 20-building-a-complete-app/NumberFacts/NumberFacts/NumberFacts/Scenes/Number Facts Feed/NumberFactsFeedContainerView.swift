//
//  NumberFactsFeedContainerView.swift
//  NumberFacts
//
//  Created by CypherPoet on 2/19/20.
// ✌️
//

import SwiftUI
import Combine
import Common
import CypherPoetSwiftUIKit


struct NumberFactsFeedContainerView {
    @ObservedObject var viewModel: ViewModel
    
    
    init(
        viewModel: ViewModel = .init()
    ) {
        self.viewModel = viewModel
    }
}



// MARK: - View
extension NumberFactsFeedContainerView: View {

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isFetching {
                    UIActivityIndicatorWrapper()
                } else if viewModel.currentNumberFact != nil {
                    NumberFactCardView(
                        viewModel: .init(
                            numberFact: viewModel.currentNumberFact!
                        ),
                        onFactLiked: self.factLiked(_:),
                        onFactDisliked: self.factDisliked(_:)
                    )
                } else {
                    Text("No Number Facts Data")
                }
            }
            .navigationBarTitle("Number Facts")
        }
        .onAppear {
            if self.viewModel.dataFetchingState == .inactive {
                self.viewModel.fetchNumberCard()
            }
        }
    }
}


// MARK: - Computeds
extension NumberFactsFeedContainerView {
}


// MARK: - View Variables
extension NumberFactsFeedContainerView {
}


// MARK: - Private Helpers
private extension NumberFactsFeedContainerView {
    
    func factLiked(_ fact: NumberFact) {
        viewModel.updateFavoriteStatus(for: fact, to: true)
        viewModel.fetchNumberCard()
    }
    
    func factDisliked(_ fact: NumberFact) {
        viewModel.updateFavoriteStatus(for: fact, to: false)
        viewModel.fetchNumberCard()
    }
}



// MARK: - Preview
struct NumberFactsFeedContainerView_Previews: PreviewProvider {

    static var previews: some View {
        NumberFactsFeedContainerView()
    }
}
