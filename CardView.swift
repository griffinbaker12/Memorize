//
//  SwiftUIView.swift
//  Memorize
//
//  Created by Griffin Baker on 3/26/24.
//

import SwiftUI

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        Pie(endAngle: .degrees(240))
            .opacity(Constants.Pie.opacity)
            .overlay(
                Text(card.content)
                    .font(.system(size: Constants.FontSize.largest))
                    // can scale down to 1/100th of prior size if the font is too big (but only did vertical size), so the hor was outside the card
                    .minimumScaleFactor(Constants.FontSize.scaleFactor)
                    // has to fit 1/1 inside 2/3
                    .aspectRatio(1, contentMode: .fit)
                    .multilineTextAlignment(.center)
                    .padding(Constants.Pie.inset)
                    .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                    .animation(.spin(for: 1), value: card.isMatched)
            )
            .padding(Constants.inset)
            .cardify(faceUp: card.faceUp)
            .opacity(card.faceUp || !card.isMatched ? 1 : 0)
    }
    
    private struct Constants {
        static let inset: CGFloat = 5
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor = smallest / largest
        }
        struct Pie {
            static let opacity: CGFloat = 0.4
            static let inset: CGFloat = 8
        }
    }
}

extension Animation {
    static func spin(for duration: TimeInterval) -> Animation {
        .linear(duration: duration).repeatForever(autoreverses: false)
    }
}

#Preview {
    typealias Card = MemoryGame<String>.Card
    
    return CardView(
        Card(content: "X", id: "test1")
    )
}
