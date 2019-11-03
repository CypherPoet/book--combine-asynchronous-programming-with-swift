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
