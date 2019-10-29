//
//  CollageGrid.swift
//  Collage
//
//  Created by CypherPoet on 10/28/19.
// ✌️
//

import SwiftUI


struct CollageGrid: View {
    var images: [Image]
}


// MARK: - Computeds
extension CollageGrid {
    var rows: Int { images.count < 3 ? 1 : 2 }
    
    var maxColumnCount: Int {
        Int(round(Double(images.count) / Double(rows)))
    }
    
    
    func columnCount(for rowIndex: Int) -> Int {
        let totalImageCount = images.count
        
        guard totalImageCount > 2 else { return totalImageCount }
        
        if rowIndex + 1 < rows {
            return maxColumnCount
        } else {
            return maxColumnCount - 1
        }
    }
    
    
    func imageIndex(forRow rowIndex: Int, column columnIndex: Int) -> Int {
        (rowIndex * self.maxColumnCount) + columnIndex
    }
    
    
    func image(forRow rowIndex: Int, column columnIndex: Int) -> Image {
        images[imageIndex(forRow: rowIndex, column: columnIndex)]
    }
    
    
    func tileSize(forRow row: Int, in geometry: GeometryProxy) -> CGSize {
        CGSize(
            width: round(geometry.size.width / CGFloat(columnCount(for: row))),
            height: round(geometry.size.height / CGFloat(rows))
        )
    }
}


// MARK: - Body
extension CollageGrid {

    var body: some View {
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                ForEach(0 ..< self.rows, id: \.self) { row in
                    
                    HStack(spacing: 0) {
                        ForEach(0 ..< self.columnCount(for: row), id: \.self) { column in
                            GridImage(
                                size: self.tileSize(forRow: row, in: geometry),
                                image: self.image(forRow: row, column: column)
                            )
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.gray, lineWidth: 4)
            )
        }
    }
    
    
    
    struct GridImage: View {
        let size: CGSize
        let image: Image
        
        var body: some View {
            return image
                .resizable()
                .scaledToFill()
        }
    }
}


// MARK: - Preview
struct CollageGrid_Previews: PreviewProvider {

    static var previews: some View {
        let sampleImages = [
            Image("image-1"),
            Image("image-2"),
            Image("image-3"),
            Image("image-4"),
        ]
        
        return CollageGrid(
            images: sampleImages
        )
    }
}
