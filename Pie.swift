//
//  File.swift
//  Memorize
//
//  Created by Griffin Baker on 3/26/24.
//

import SwiftUI
// because there are many different Swift packages that have cos and sin in them
import CoreGraphics

// TODO: visualizing how something like this actually gets drawn
struct Pie: Shape {
    var startAngle: Angle = .zero
    var endAngle: Angle
    let clockwise = false

    func path(in rect: CGRect) -> Path {
        let startAngle = startAngle - .degrees(90)
        let endAngle = endAngle - .degrees(90)
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * cos(startAngle.radians),
            y: center.y + radius * sin(startAngle.radians)
       )
        
        // TODO: is the call with these named params to have it read like English or spoken language?
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        p.addLine(to: center)
        
        return p
    }
    
    
}
