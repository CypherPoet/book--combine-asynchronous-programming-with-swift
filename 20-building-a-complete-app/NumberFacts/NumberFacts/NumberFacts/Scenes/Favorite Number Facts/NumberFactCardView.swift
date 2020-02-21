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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @ObservedObject var viewModel: ViewModel
    
    let onFactLiked: ((NumberFact) -> Void)
    let onFactDisliked: ((NumberFact) -> Void)
}


// MARK: - View
extension NumberFactCardView: View {

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Text(self.viewModel.numberFactText)
                    .font(.title)
                Spacer()
                Spacer()
                
                self.translateToggle
            }
            .padding()
            .frame(
                width: self.cardWidth(in: geometry),
                height: self.cardHeight(in: geometry)
            )
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(
                RoundedRectangle(cornerRadius: 22)
            )
            .shadow(color: .gray, radius: 12, x: 0, y: 0)
        }
    }
}


// MARK: - Computeds
extension NumberFactCardView {
}


// MARK: - View Variables
extension NumberFactCardView {

    private var translateToggle: some View {
        Toggle(isOn: $viewModel.isShowingTranslation) {
            Text("Toggle Translation")
        }
    }
}


// MARK: - Private Helpers
private extension NumberFactCardView {
    
    func cardWidth(in geometry: GeometryProxy) -> CGFloat {
        (
            self.horizontalSizeClass == .compact ?
                geometry.size.width
                : geometry.size.height
        )
        * 0.667
    }
    
    func cardHeight(in geometry: GeometryProxy) -> CGFloat {
        cardWidth(in: geometry) * (self.horizontalSizeClass == .compact ? (5 / 3) : (3 / 5))
    }
}



// MARK: - Preview
struct NumberFactCardView_Previews: PreviewProvider {

    static var previews: some View {
        NumberFactCardView(
            viewModel: .init(
                numberFact: PreviewData.NumberFacts.sample1
            ),
            onFactLiked: { _ in },
            onFactDisliked: { _ in }
        )
        .environment(\.horizontalSizeClass, .compact)
    }
}
