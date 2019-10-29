//
//  UIImage+Collage.swift
//  Collage
//
//  Created by CypherPoet on 10/28/19.
// ✌️
//

import UIKit
import Foundation

//
//extension UIImage {
//    
//    static func collage(from images: [UIImage], size: CGSize) -> UIImage {
//        let rows = images.count < 3 ? 1 : 2
//        let columns = Int(round(Double(images.count) / Double(rows)))
//        
//        let tileSize = CGSize(
//            width: round(size.width / CGFloat(columns)),
//            height: round(size.height / CGFloat(rows))
//        )
//        
//        UIGraphicsBeginImageContextWithOptions(size, true, 0)
//        
//        UIColor.white.setFill()
//        UIRectFill(CGRect(origin: .zero, size: size))
//        
//        for (index, image) in images.enumerated() {
//            let imageAnchorPoint = CGPoint(
//                x: CGFloat(index % columns) * tileSize.width,
//                y: CGFloat(index / columns) * tileSize.height
//            )
//            
//            
////            image.scaled(tileSize).draw(at: imageAnchorPoint)
//        }
//        
//        
//    }
//}
