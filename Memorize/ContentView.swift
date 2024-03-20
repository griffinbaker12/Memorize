//
//  ContentView.swift
//  Memorize
//
//  Created by Griffin Baker on 3/18/24.
//

import SwiftUI

// declaring a type here named ContentView, and it is a struct
struct ContentView: View {
    let emojis = ["👻", "🎃", "🕷️",  "😈"]

    // putting View here makes no sense, because we are supposed to be telling the compiler what View we actually want to return here
    var body: some View {
        HStack {
            ForEach(emojis.indices, id: \.self) { index in
                CardView(content: emojis[index])
            }
        }
        .foregroundColor(.orange)
        .padding()
    }
}

struct CardView: View {
    let content: String
    // @State creates a pointer, the pointer itself never changes; the thing it points to can change, so satisfies the requirement that the View can't change, but isFaceUp can change
    @State var isFaceUp = true
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            if isFaceUp {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            } else {
                // this percolates from above
                // don't need the .fill modifier, but that is what is happening above
                base.fill()
            }
        }
        .onTapGesture {
            // self, or the view itself in this case, is immutable...and even thought that is a var, that "varness" is only at the very beginning (without the @State)
            // @State is for small things, like flipping the card over, not the state of the game or anything like that
//            isFaceUp = !isFaceUp
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}
