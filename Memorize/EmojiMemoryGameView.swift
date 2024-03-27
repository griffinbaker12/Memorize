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
    private let dealAnimation: Animation = .spring(.bouncy(duration: 0.65, extraBounce: -0.12))
    private let dealDelay: TimeInterval = 0.15
    private let deckWidth: CGFloat = 50

    // putting View here makes no sense, because we are supposed to be telling the compiler what View we actually want to return here
    // @ViewBuilder is implicit here
    var body: some View {
        VStack {
            cards.foregroundColor(viewModel.color)
//                // needs to conform to equatable
//                .animation(.default, value: viewModel.cards)
            HStack {
                score
                Spacer()
                deck.foregroundColor(viewModel.color)
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
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            Group {
                if isDealt(card) {
                    CardView(card)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .transition(.asymmetric(insertion: .identity, removal: .identity))
                        .padding(spacing)
                        .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                        .zIndex(scoreChange(causedBy: card) != 0 ? 1 : 0)
                        .onTapGesture {
                            choose(card)
                        }
                }
            }
        }
    }
    
    // great and obvious use because only part of UI, not model
    @State private var dealt = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter { !isDealt($0) }
    }
    
    @Namespace private var dealingNamespace
    
    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
               CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        .onTapGesture {
            deal()
        }
    }
    
    private func deal() {
        var delay: TimeInterval = 0
        for card in viewModel.cards {
            withAnimation(dealAnimation.delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += dealDelay
        }
    }
    
    private func choose(_ card: Card) {
        withAnimation {
            let scoreBeforeChoosing = viewModel.score
            viewModel.choose(card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }
    
    @State private var lastScoreChange = (0, causedByCardId: "")
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, id) = lastScoreChange
        return card.id == id ? amount : 0
        // .1 on a tuple means the second thing in there
//        return lastScoreChange.1 == card.id ? ...
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
