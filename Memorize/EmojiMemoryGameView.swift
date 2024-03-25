//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Griffin Baker on 3/18/24.
//

import SwiftUI

// declaring a type here named ContentView, and it is a struct
struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    // putting View here makes no sense, because we are supposed to be telling the compiler what View we actually want to return here
    var body: some View {
        VStack {
            ScrollView {
                cards
                    // needs to conform to equatable
                    .animation(.default, value: viewModel.cards)
            }
            Button("Shuffle") {
                // view talking to the view model through an intent
                viewModel.shuffle()
            }
            .padding()
        }
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0) {
            ForEach(viewModel.cards) { card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
        .foregroundColor(.orange)
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
                    // can scale down to 1/100th of prior size if the font is too big (but only did vertical size), so the hor was outside the card
                    .minimumScaleFactor(0.01)
                    // has to fit 1/1 inside 2/3
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.faceUp ? 1 : 0)
            base.fill().opacity(card.faceUp ? 0 : 1)
        }
        .opacity(card.faceUp || !card.isMatched ? 1 : 0)
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
