//
//  Cardify.swift
//  Memorize
//
//  Created by Griffin Baker on 3/26/24.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable {
    // we take control here and they stopped being done automatically by defining faceUp based on the rotation
    init (faceUp: Bool) {
        rotation = faceUp ? 0 : 180
    }
    
    var faceUp: Bool {
        // wow
        rotation < 90
    }
    
    var rotation: Double
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            base.strokeBorder(lineWidth: Constants.lineWidth)
                .background(base.fill(.white))
                .overlay(content)
                .opacity(faceUp ? 1 : 0)
            base.fill().opacity(faceUp ? 0 : 1)
        }
        .rotation3DEffect(
            .degrees(rotation),
            axis: (0, 1, 0)
        )
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
    }
}

extension View {
    func cardify(faceUp: Bool) -> some View {
        self.modifier(Cardify(faceUp: faceUp))
    }
}
