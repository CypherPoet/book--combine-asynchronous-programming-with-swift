//
//  ImageCollage.swift
//  Collage
//
//  Created by CypherPoet on 10/28/19.
// ✌️
//

import SwiftUI


struct ImageCollage {
    let id = UUID()
    
    var name: String
    var processedImage: UIImage?
}



extension ImageCollage: Identifiable {}

extension ImageCollage: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}


#if DEBUG

let sampleCollage = ImageCollage(
    name: "Mass Effect",
    processedImage: nil
)

#endif
