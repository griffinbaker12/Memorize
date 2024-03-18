//
//  ContentView.swift
//  Memorize
//
//  Created by Griffin Baker on 3/18/24.
//

import SwiftUI

// declaring a type here named ContentView, and it is a struct
struct ContentView: View {
//    var body: Text {
//        // actually awesome that SwiftUI will create the TupleView for us here...
//        Text("hey")
//        Text("yo")
//    }
    
    // putting View here makes no sense, because we are supposed to be telling the compiler what View we actually want to return here
    var body: some View {
        HStack {
            CardView(isFaceUp: false)
            CardView()
            CardView()
            CardView()
        }
        .foregroundColor(.orange)
        .padding()
    }
}

struct CardView: View {
    // @State creates a pointer, the pointer itself never changes; the thing it points to can change, so satisfies the requirement that the View can't change, but isFaceUp can change
    @State var isFaceUp = false
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            if isFaceUp {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text("👻").font(.largeTitle)
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
