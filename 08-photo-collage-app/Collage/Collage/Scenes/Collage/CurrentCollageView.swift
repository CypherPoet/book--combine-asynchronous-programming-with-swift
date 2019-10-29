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
    @ObservedObject var viewModel = CurrentCollageViewModel()
    
    var onSave: (() -> Void)
    var onClear: (() -> Void)
}


// MARK: - Body
extension CurrentCollageView {

    var body: some View {
        VStack(spacing: 20) {
            Group {
                if viewModel.isEmpty {
                    Rectangle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 300, height: 300)
                        .padding()
                        .overlay(
                            Text("Start Adding Images to Your Collage")
                        )
                } else {
                    CollageGrid(images: viewModel.collage.images)
                        .padding()
                }
            }
            
            
            Button(action: onSave) {
                Text("Save")
                    .fontWeight(.bold)
            }
            .buttonStyle(CustomFilledButtonStyle(width: 200))

            
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
        .navigationBarTitle("Collage", displayMode: .large)
        .navigationBarItems(trailing: addButton)
    }
}


// MARK: - View Variables
extension CurrentCollageView {
    
    private var addButton: some View {
        Button(action: addImage) {
            Image(systemName: "plus")
                .imageScale(.large)
        }
    }
}


extension CurrentCollageView {
        
    private func addImage() {
        viewModel.collage.images.append(Image("image-1"))
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
