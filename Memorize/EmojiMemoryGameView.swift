//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Griffin Baker on 3/18/24.
//

import SwiftUI

// declaring a type here named ContentView, and it is a struct
struct EmojiMemoryGameView: View {
    typealias Card = MemoryGame<String>.Card
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let aspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 4
    
    // putting View here makes no sense, because we are supposed to be telling the compiler what View we actually want to return here
    // @ViewBuilder is implicit here
    var body: some View {
        VStack {
            cards
                .foregroundColor(viewModel.color)
//                // needs to conform to equatable
//                .animation(.default, value: viewModel.cards)
            HStack {
                score
                Spacer()
                shuffle
            }
            .font(.title2)
        }
        .padding()
    }
    
    private var score: some View {
        Text("Score: \(viewModel.score)")
            .animation(nil)
    }
    
    private var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                // view talking to the view model through an intent
                viewModel.shuffle()
            }
        }
    }
    
    // look at the content of computed property as if it was a ViewBuilder
    private var cards: some View {
        // takes all the space, whereas LazyVGrid only took space offered before
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            CardView(card)
                .padding(spacing)
                .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                .onTapGesture {
                    withAnimation {
                        viewModel.choose(card)
                    }
                }
        }
    }
    
    private func scoreChange(causedBy card: Card) -> Int {
        0
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
