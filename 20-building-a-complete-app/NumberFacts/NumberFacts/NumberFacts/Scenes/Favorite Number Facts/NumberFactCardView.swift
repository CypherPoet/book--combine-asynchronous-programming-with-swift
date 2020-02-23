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
    
    private let cardSlideAnimationDuration = 0.4

    @ObservedObject var viewModel: ViewModel
    
    let onFactLiked: ((NumberFact) -> Void)
    let onFactDisliked: ((NumberFact) -> Void)
    
    @GestureState private var dragState: DragState = .inactive
}


// MARK: - View
extension NumberFactCardView: View {

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.likedHUDView
                    .frame(
                        width: self.cardWidth(in: geometry) * 0.7,
                        height: self.cardWidth(in: geometry) * 0.7
                    )
                    .opacity(self.likedHUDViewOpacity)
                    .animation(self.hudAnimation)
                
                
                self.dislikedHUDView
                    .frame(
                        width: self.cardWidth(in: geometry) * 0.7,
                        height: self.cardWidth(in: geometry) * 0.7
                    )
                    .opacity(self.dislikedHUDViewOpacity)
                    .animation(self.hudAnimation)


                self.numberCard
                    .frame(
                        width: self.cardWidth(in: geometry),
                        height: self.cardHeight(in: geometry)
                    )
                    .shadow(color: .gray, radius: 12, x: 0, y: 0)
                    .gesture(self.cardDragGesture(in: geometry))
                    .offset(self.finalDragOffset)
                    .animation(Animation.easeOut(duration: self.cardSlideAnimationDuration))
            }
        }
    }
}


// MARK: - Computeds
extension NumberFactCardView {
    
    var likedHUDViewOpacity: Double {
        switch viewModel.decisionState {
        case .liked:
            return 1.0
        case .disliked,
             .undecided:
            return 0.0
        }
    }
    
    
    var dislikedHUDViewOpacity: Double {
        switch viewModel.decisionState {
        case .liked,
             .undecided:
            return 0.0
        case .disliked:
            return 1.0
        }
    }
    
    
    var hudAnimation: Animation {
        Animation
            .easeOut(duration: 0.3)
            .delay(self.cardSlideAnimationDuration)
    }
    
    
    var finalDragOffset: CGSize {
        switch viewModel.decisionState {
        case .liked:
            return .init(
                width: self.dragState.dragWidth + UIScreen.main.bounds.width,
                height: 0
            )
        case .disliked:
            return .init(
                width: self.dragState.dragWidth - UIScreen.main.bounds.width,
                height: 0
            )
        case .undecided:
            return .init(
                width: self.dragState.dragWidth,
                height: 0
            )
        }
    }
    
    
    var cardBackgroundColor: Color {
        switch dragState.dragWidth {
        case 0.5...:
            return .green
        case ...(-1 * 0.5):
            return .red
        default:
            return Color(UIColor.secondarySystemBackground)
        }
    }
    
    
    func cardDragGesture(in geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .updating($dragState) { (value, dragState, _) in
                dragState = .dragging(value.translation)
            }
            .onEnded { finalDragValue in
                let frameWidth = geometry.frame(in: .local).size.width
                let cardWidth = self.cardWidth(in: geometry)
                
                switch finalDragValue.predictedEndLocation.x {
                case (frameWidth - (cardWidth * 0.5))...:
                    self.onFactLiked(self.viewModel.numberFact)
                    self.viewModel.decisionState = .liked
                case ...(cardWidth * -0.5):
                    self.onFactDisliked(self.viewModel.numberFact)
                    self.viewModel.decisionState = .disliked
                default:
                    break
                }
            }
    }
}


// MARK: - View Variables
extension NumberFactCardView {
    
    private var likedHUDView: some View {
        Image(systemName: "hand.thumbsup.fill")
            .resizable()
            .foregroundColor(.green)
    }
    
    
    private var dislikedHUDView: some View {
        Image(systemName: "hand.thumbsdown.fill")
            .resizable()
            .foregroundColor(.red)
    }
    

    private var numberCard: some View {
        VStack {
            Spacer()
            Text(viewModel.numberFactText)
                .font(.title)
            Spacer()
            Spacer()

            translationToggle
        }
        .padding()
        .background(cardBackgroundColor)
        .clipShape(
            RoundedRectangle(cornerRadius: 22)
        )
    }
    
    
    private var translationToggle: some View {
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


// MARK: - DragState
extension NumberFactCardView {
    
    enum DragState {
        case inactive
        case dragging(_ translation: CGSize)
    }
}

extension NumberFactCardView.DragState {
    
    var dragWidth: CGFloat {
        guard case let .dragging(translation) = self else { return 0.0 }

        return translation.width
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
//        .previewLayout(.sizeThatFits)
    }
}
