//: [Previous](@previous)

import Foundation
import Combine
import UIKit


//: ## Catching & Retrying

var subscriptions = Set<AnyCancellable>()
let photoService = PhotoService()



func handleReceive(completion: Subscribers.Completion<PhotoService.Error>) {
    switch completion {
    case .failure(.failedFetching(let quality)):
        print("Error while fetching photo of quality \(quality)")
    case .finished:
        print("Finished successfully!")
    }
}


func handleReceive(completion: Subscribers.Completion<Never>) {
    switch completion {
    case .finished:
        print("Finished successfully!")
    }
}



func handleReceive(subscription: Subscription) {
    print("Subscription received...")
}


func handleReceive(value image: UIImage) {
    image
    print("Received image: \(image)")
}



demo(describing: "Retrying when a publisher completes with an error") {

//    photoService.fetchPhoto(quality: .low)
////        .retry(4)
//        .handleEvents(
//            receiveSubscription: handleReceive(subscription:)
////            receiveOutput: handleReceive(value:),
////            receiveCompletion: handleReceive(completion:)
//        )
//        .sink(receiveCompletion: handleReceive(completion:), receiveValue: handleReceive(value:))
//        .store(in: &subscriptions)
    
    
    photoService.fetchPhoto(quality: .high, failingTimes: 2)
        .handleEvents(
            receiveSubscription: handleReceive(subscription:),
            receiveCompletion: handleReceive(completion:)
        )
        .retry(3)
        .sink(receiveCompletion: handleReceive(completion:), receiveValue: handleReceive(value:))
        .store(in: &subscriptions)
}




demo(describing: "Retrying, then catching if the upstream publisher is still failing") {
    photoService.fetchPhoto(quality: .high)
        .handleEvents(
            receiveSubscription: handleReceive(subscription:),
            receiveCompletion: handleReceive(completion:)
        )
        .retry(3)
        .catch { error in
            photoService.fetchPhoto(quality: .low)
        }
        .replaceError(with: UIImage(named: "na.jpg")!)
        .sink(receiveCompletion: handleReceive(completion:), receiveValue: handleReceive(value:))
        
        .store(in: &subscriptions)
}


//: [Next](@next)
