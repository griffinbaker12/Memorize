//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Griffin Baker on 3/21/24.
//

// this ViewModel is specific for Emoji Memory games
// the ViewModel is part of the UI (packaging up the model for the UI, so it has to know what the UI looks like); it won't be creating views or anything like that
import SwiftUI

// want to list the super class before the other things that you behave like
class EmojiMemoryGame: ObservableObject {
    // its whole job in a way is to understand the Model and talk to it and interpret the data and present it to the View in a really nice way
    // you can add `private` to make the sepation full b/c otherwise the view could directly edit the model
//    private var model = MemoryGame(
//        numberOfPairsOfCards: 4
//    ) {
//        return ["👻", "🎃", "🕷️", "😈", "🧛", "👽", "🤖", "🧟", "💀", "👹", "🕹️", "🪩"][$0]
//    }
    
    // make emojis global, but namespace it inside of the class and then make it private so only we can use it!
    // globals get initialized first, so
    private static let emojis = ["👻", "🎃", "🕷️", "😈", "🧛", "👽", "🤖", "🧟", "💀", "👹", "🕹️", "🪩"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame(
            numberOfPairsOfCards: 8
        ) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                return "⁉"
            }
        }
    }
    
    
    // need to have this here so that we don't need an initializer (want to give it a value to start, else...)
    // order properties are initialized is undetermined and not in the order of source
    // have to initialize yourself first before calling your own functions
    // return types always have to be explicit, cannot be inferred in Swift
    @Published private var model = createMemoryGame()

    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intents
    func shuffle() {
        model.shuffle()
    }
    
    // intent function
    // we did not use a name here because it is obvious that you are passing a card
    // would want to use it for strings and ints if you can't tell what it is, or if it makes the code read a lot better
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}
