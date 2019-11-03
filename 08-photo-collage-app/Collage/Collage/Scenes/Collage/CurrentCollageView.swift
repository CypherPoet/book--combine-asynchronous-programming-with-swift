//
//  CurrentCollageView.swift
//  Collage
//
//  Created by CypherPoet on 10/28/19.
// ✌️
//

import SwiftUI
import CypherPoetSwiftUIKit_ButtonStyles



struct CurrentCollageView: View {
    @ObservedObject private(set) var viewModel: CurrentCollageViewModel
    
    var onSave: (() -> Void)
    var onClear: (() -> Void)
}



// MARK: - Body
extension CurrentCollageView {

    var body: some View {
        VStack(spacing: 22) {

            HStack {
                imageCountLabel
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            Group {
                if viewModel.isEmpty {
                    Rectangle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 300, height: 300)
                        .overlay(
                            Text("Start Adding Images to Your Collage")
                        )
                } else {
                    CollageGrid(collage: viewModel.collagePreview)
                }
            }
            
            
            VStack(spacing: 12.0) {
                Button(action: onSave) {
                    Text("Save")
                        .fontWeight(.bold)
                }
                .buttonStyle(CustomFilledButtonStyle(width: 200))
                .disabled(!viewModel.isSaveEnabled)

                Button(action: onClear) {
                    Text("Clear")
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                }
                .buttonStyle(CustomFilledButtonStyle(
                    width: 200,
                    fillColor: Color.gray.opacity(0.2),
                    foregroundColor: .blue
                ))
            }
        }
        .padding()
        .navigationBarTitle("Collage", displayMode: .large)
        .navigationBarItems(trailing: addButton)
    }
}


// MARK: - View Variables
extension CurrentCollageView {
    
    private var imageCountLabel: Text {
        Text(viewModel.sourceImageCountText)
    }
    
    private var addButton: some View {
        Button(action: addImage) {
            Image(systemName: "plus")
                .imageScale(.large)
        }
        .disabled(!viewModel.isAddEnabled)
    }
}


extension CurrentCollageView {
        
    private func addImage() {
        guard let image = UIImage(named: "image-1") else { preconditionFailure() }
        
        viewModel.sourceImages.append(image)
    }
}


// MARK: - Preview
struct CurrentCollageView_Previews: PreviewProvider {

    static var previews: some View {
        let viewModel = CurrentCollageViewModel(collage: sampleCollage)
        
        return CurrentCollageView(
            viewModel: viewModel,
            onSave: {},
            onClear: {}
        )
        .accentColor(.pink)
    }
}
