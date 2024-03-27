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
    private(set) var score = 0
   
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
                        score += 2 + cards[chosenIndex].bonus + cards[existingIndex].bonus
                    } else {
                        if cards[chosenIndex].hasBeenSeen {
                            score -= 1
                        }
                        if cards[existingIndex].hasBeenSeen {
                            score -= 1
                        }
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
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var debugDescription: String {
            "\(id): \(content) \(faceUp ? "up" : "down") \(isMatched ? "matched" : "")"
        }
        
        var faceUp = false {
            didSet {
                if faceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
                if oldValue && !faceUp {
                    hasBeenSeen = true
                }
            }
        }
        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        var hasBeenSeen = false
        let content: CardContent
        
        var id: String
        // MARK: - Bonus Time
        
        // call this when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if faceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }
        
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime) / bonusTimeLimit : 0
        }
        
        // how long this card has ever been face up and unmatched during its lifetime
        // basically, pastFaceUpTime + time since lastFaceUpDate
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // can be zero which would mean "no bonus available" for matching this card quickly
        var bonusTimeLimit: TimeInterval = 6
        
        // the last time this card was turned face up
        var lastFaceUpDate: Date?
        
        // the accumulated time this card was face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
    }
}

extension Array {
    var only: Element? {
        // these are things in Array and I am in an Array
        count == 1 ? first : nil
    }
}
