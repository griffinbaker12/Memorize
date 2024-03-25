//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Griffin Baker on 3/21/24.
//

import Foundation

// model for any kind of card game that follows the same rules (ie, anything could be on the card)
struct MemoryGame<CardContent> where CardContent: Equatable {
    // don't want other people interfering with game logic by flipping cards over externally but we want people to see the cards
    // using things like private and private(set) is something called access control
    private(set) var cards: Array<Card>
   
    // job of init is to initialize all of your vars
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex+1)a"))
            cards.append(Card(content: content, id: "\(pairIndex+1)b"))
        }
    }
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { index in cards[index].faceUp }.only }
        set { cards.indices.forEach { cards[$0].faceUp = (newValue == $0) } }
    }
    
    mutating func choose(card: Card) {
        // we are being passed a value type though...or a copy so need to use our source of truth...the model!
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenIndex].faceUp && !cards[chosenIndex].isMatched {
                if let existingIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[existingIndex].content == cards[chosenIndex].content {
                        cards[existingIndex].isMatched = true
                        cards[chosenIndex].isMatched = true
                    }
                } else {
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].faceUp = true
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
        print(cards)
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var debugDescription: String {
            "\(id): \(content) \(faceUp ? "up" : "down") \(isMatched ? "matched" : "")"
        }
        
        var faceUp = false
        var isMatched = false
        let content: CardContent
        
        var id: String
    }
}

extension Array {
    var only: Element? {
        // these are things in Array and I am in an Array
        count == 1 ? first : nil
    }
}
