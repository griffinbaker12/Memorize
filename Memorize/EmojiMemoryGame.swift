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
class EmojiMemoryGame {
    var model: MemoryGame<String>
}
