//
//  AspectVGrid.swift
//  Memorize
//
//  Created by Griffin Baker on 3/25/24.
//

import SwiftUI

// using this Generic syntax is a way to let Swift know that we will be using these types within our struct and what they must conform to
//struct AspectVGrid<Item>: View where Item: Identifiable {
struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    var items: [Item]
    var aspectRatio: CGFloat = 1
    var content: (Item) -> ItemView
    
    init(_ items: [Item], aspectRatio: CGFloat, content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let gridItemSize = gridItemWidthThatFits(
                count: items.count,
                size: geometry.size,
                atAspectRatio: aspectRatio
            )
            // this GridIten defines each column
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                ForEach(items) { item in
                    content(item)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }
        
    func gridItemWidthThatFits(count: Int, size: CGSize, atAspectRatio aspectRatio: CGFloat) -> CGFloat {
        let count = CGFloat(count)
        var columnCount = 1.0
        repeat {
            // all of the cards, divided by the number of columns, starts out big!
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            // need to round up if you had 3 cards and 2 columns
            let rowCount = (count / columnCount).rounded(.up)
            
            // how many rows * height of each card (row)...if it can be allocated
            if rowCount * height < size.height {
                //                 round down to ensure it fits
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        } while columnCount < count
        
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
}
