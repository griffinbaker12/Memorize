//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Griffin Baker on 3/21/24.
//

import Foundation

// model for any kind of card game that follows the same rules (ie, anything could be on the card)
struct MemoryGame<CardContent> {
    // don't want other people interfering with game logic by flipping cards over externally but we want people to see the cards
    // using things like private and private(set) is something called access control
    private(set) var cards: Array<Card>
   
    // job of init is to initialize all of your vars
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    func choose(card: Card) {
        
    }
    
    struct Card {
        var faceUp = false
        var isMatched = false
        let content: CardContent
    }
}
