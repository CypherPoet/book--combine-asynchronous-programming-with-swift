//
//  UIImage+Collage.swift
//  Collage
//
//  Created by CypherPoet on 10/28/19.
// ✌️
//

import UIKit
import Foundation


extension UIImage {
    static func collage(images: [UIImage], size: CGSize) -> UIImage {
        let rows = images.count < 3 ? 1 : 2
        let columns = Int(round(Double(images.count) / Double(rows)))
        let tileSize = CGSize(width: round(size.width / CGFloat(columns)),
                              height: round(size.height / CGFloat(rows)))
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        UIColor.white.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        
        for (index, image) in images.enumerated() {
            image.scaled(tileSize).draw(at: CGPoint(
                x: CGFloat(index % columns) * tileSize.width,
                y: CGFloat(index / columns) * tileSize.height
            ))
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    func scaled(_ newSize: CGSize) -> UIImage {
        guard size != newSize else {
            return self
        }
        
        let ratio = max(newSize.width / size.width, newSize.height / size.height)
        let width = size.width * ratio
        let height = size.height * ratio
        
        let scaledRect = CGRect(
            x: (newSize.width - width) / 2.0,
            y: (newSize.height - height) / 2.0,
            width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0);
        defer { UIGraphicsEndImageContext() }
        
        draw(in: scaledRect)
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}
