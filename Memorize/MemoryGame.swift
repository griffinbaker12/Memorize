//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Griffin Baker on 3/21/24.
//

import Foundation

// model for any kind of card game that follows the same rules (ie, anything could be on the card)
struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    func choose(card: Card) {
        
    }
    
    struct Card {
        var faceUp: Bool
        var isMatched: Bool
        var content: CardContent
    }
}
