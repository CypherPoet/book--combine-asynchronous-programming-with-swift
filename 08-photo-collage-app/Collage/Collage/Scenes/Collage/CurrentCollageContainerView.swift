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
    private var viewModel = CurrentCollageContainerViewModel()
    
    @State private var isShowingSaveAlert = false
    @State private var isShowingPhotosAuthAlert = false
    @State private var latestSavedCollageId: String? = nil
    @State private var saveErrorTitle: String? = nil
    @State private var saveErrorMessage: String? = nil
}


// MARK: - Body
extension CurrentCollageContainerView {

    var body: some View {
        NavigationView {
            CurrentCollageView(
                viewModel: CurrentCollageViewModel(),
                onSave: save(imageCollage:)
            )
        }
        .alert(isPresented: $isShowingSaveAlert, content: { self.onSaveAlert })
        .alert(isPresented: $isShowingPhotosAuthAlert, content: { self.photosAuthorizationAlert })
    }
}


// MARK: - Computeds
extension CurrentCollageContainerView {
    
    private var saveAlertTitle: Text { Text(saveErrorTitle ?? "Success") }

    private var saveAlertMessage: Text? {
        if let errorMessage = saveErrorMessage {
            return Text(errorMessage)
        } else {
            guard let id = latestSavedCollageId else { preconditionFailure() }
            return Text("Saved with id: \(id)")
        }
    }
}


// MARK: - View Variables
extension CurrentCollageContainerView {
    
    private var onSaveAlert: Alert {
        Alert(
            title: saveAlertTitle,
            message: saveAlertMessage,
            dismissButton: .default(Text("OK"))
        )
    }
    
    private var photosAuthorizationAlert: Alert {
        Alert(
            title: Text("No access to Camera Roll"),
            message: Text("You can grant access to Collage from the Settings app."),
            dismissButton: .default(Text("OK"))
        )
    }
}


// MARK: - Private Helpers
extension CurrentCollageContainerView {

    private func save(imageCollage: ImageCollage) {
        guard let processedImage = imageCollage.processedImage else {
            preconditionFailure("Save should be disabled when no collage image is present")
        }
        
        guard viewModel.isPhotoWriterAuthorized else {
            isShowingPhotosAuthAlert = true
            return
        }

        _ = PhotoWriter.save(processedImage)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        self.isShowingSaveAlert = true
                        self.saveErrorTitle = "An error occurred while trying to save:"
                        self.saveErrorMessage = error.localizedDescription
                    }
                },
                receiveValue: { photoId in
                    self.isShowingSaveAlert = true
                    self.saveErrorTitle = nil
                    self.saveErrorMessage = nil
                    self.latestSavedCollageId = photoId
                }
            )
            
    }
}


// MARK: - Preview
struct CurrentCollageContainerView_Previews: PreviewProvider {

    static var previews: some View {
        CurrentCollageContainerView()
    }
}
