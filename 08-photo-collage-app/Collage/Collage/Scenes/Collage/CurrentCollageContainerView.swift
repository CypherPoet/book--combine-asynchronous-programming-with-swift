//
//  CurrentCollageContainerView.swift
//  Collage
//
//  Created by CypherPoet on 10/28/19.
// ✌️
//

import SwiftUI
import Combine


struct CurrentCollageContainerView: View {
//    @Environment var store: AppStore
    
    private var viewModel = CurrentCollageViewModel()
    
    @State private var isShowingSaveAlert = false
    @State private var latestSavedCollageId: String? = nil
    @State private var saveErrorMessage: String? = nil
}


// MARK: - Body
extension CurrentCollageContainerView {

    var body: some View {
        NavigationView {
            CurrentCollageView(
                viewModel: viewModel,
                onSave: saveCollage,
                onClear: clearCollage
            )
        }
        .alert(isPresented: $isShowingSaveAlert, content: { self.saveAlert })
    }
}


// MARK: - View Variables
extension CurrentCollageContainerView {
    
    private var saveAlertTitle: Text {
        if let errorMessage = saveErrorMessage {
            return Text(errorMessage)
        } else {
            guard let id = latestSavedCollageId else { preconditionFailure() }
            
            return Text("Saved with id: \(id)")
        }
    }
    

    private var saveAlertMessage: Text? {
        guard saveErrorMessage != nil else { return nil }
        
        return Text("An error occurred while trying to save:")
    }
}


// MARK: - View Variables
extension CurrentCollageContainerView {
    
    private var saveAlert: Alert {
        Alert(
            title: saveAlertTitle,
            message: saveAlertMessage,
            dismissButton: .default(Text("OK"))
        )
    }
}


// MARK: - Private Helpers
extension CurrentCollageContainerView {

    private func saveCollage() {
        guard let processedImage = viewModel.collagePreview.processedImage else {
            preconditionFailure("Save should be disabled when no collage image is present")
        }
        
        
        // TODO: Place this in a `CollageState` struct, then send an action to the store from here.?
        // That could also be the responsibility of the PhotoWriter if it knew it was doing
        // something that affected state
        _ = PhotoWriter.save(processedImage)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        self.isShowingSaveAlert = true
                        self.saveErrorMessage = error.localizedDescription
                    }
                },
                receiveValue: { photoId in
                    self.isShowingSaveAlert = true
                    self.saveErrorMessage = nil
                    self.latestSavedCollageId = photoId
                }
            )
            
    }
    
    
    private func clearCollage() {
        viewModel.clearCollage()
    }
}


// MARK: - Preview
struct CurrentCollageContainerView_Previews: PreviewProvider {

    static var previews: some View {
        CurrentCollageContainerView()
    }
}
