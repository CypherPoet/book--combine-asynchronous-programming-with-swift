//
//  CollageWriter.swift
//  Collage
//
//  Created by CypherPoet on 10/31/19.
// ✌️
//

import Foundation
import UIKit
import Photos

import Combine


enum PhotoWriter {
    enum Error: Swift.Error {
        case couldNotSavePhoto
        case generic(Swift.Error)
    }
    
    
    static var isAuthorized: Future<Bool, Never> {
        Future { resolve in
            PHPhotoLibrary.requestAuthorization({ authStatus in
                switch authStatus {
                case .authorized:
                    resolve(.success(true))
                case .notDetermined,
                     .restricted,
                     .denied:
                    resolve(.success(false))
                 @unknown default:
                    resolve(.success(false))
                }
            })
        }
    }
    
    
    static func save(_ image: UIImage) -> Future<String, PhotoWriter.Error> {
        Future { resolve in
            do {
                // 1
                try PHPhotoLibrary.shared().performChangesAndWait {
                    // 2
                    let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    
                    // 3
                    guard let savedAssetID =
                        request.placeholderForCreatedAsset?.localIdentifier else {
                            return resolve(.failure(.couldNotSavePhoto))
                    }
                    
                    // 4
                    resolve(.success(savedAssetID))
                }
            } catch {
                resolve(.failure(.generic(error)))
            }
        }
    }
}
