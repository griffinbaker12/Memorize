//
//  ContentView.swift
//  Memorize
//
//  Created by Griffin Baker on 3/18/24.
//

import SwiftUI

// declaring a type here named ContentView, and it is a struct
struct ContentView: View {
    let emojis = ["👻", "🎃", "🕷️", "😈", "🧛", "👽", "🤖", "🧟", "💀", "👹", "🕹️", "🪩"];
    
    @State var cardCount = 4
    
    // putting View here makes no sense, because we are supposed to be telling the compiler what View we actually want to return here
    var body: some View {
        VStack {
            ScrollView {
                cards
            }
            Spacer()
            cardCountAdjusters
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
            ForEach(0..<cardCount, id: \.self) { index in
                CardView(content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(.orange)
    }
    
    var cardCountAdjusters: some View {
        HStack {
            cardRemover
            Spacer()
            cardAdder
        }
        .imageScale(.small)
        .font(.largeTitle)
    }
    
    func cardCountAdjuster(by offset: Int, symbol: String) -> some View {
        let countPlusOffset = cardCount + offset
        return Button(action: {
            cardCount += offset
        }, label: {
            Image(systemName: symbol)
        })
        .disabled(countPlusOffset < 1 || countPlusOffset > emojis.count)
    }
    
    var cardRemover: some View {
        cardCountAdjuster(by: -1, symbol: "rectangle.stack.badge.minus.fill")
    }
    
    var cardAdder: some View {
        cardCountAdjuster(by: 1, symbol: "rectangle.stack.badge.plus.fill")
    }
}

struct CardView: View {
    let content: String
    // @State creates a pointer, the pointer itself never changes; the thing it points to can change, so satisfies the requirement that the View can't change, but isFaceUp can change
    @State var isFaceUp = true
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
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
