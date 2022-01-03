//
//  ContentView.swift
//  sueca
//
//  Created by Daniela Palumbo on 15/09/21.
// https://www.hackingwithswift.com/books/ios-swiftui/adding-and-deleting-cards

import SwiftUI

struct ContentView: View {
    @State private var cartaAtual = "Joker"
    @State private var cards = [Card]()
    @State private var showingEditScreen = false

    var body: some View {
        ZStack {
            Color.purple.ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()

                    Button(action: {
                        self.showingEditScreen = true
                    }) {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }

                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            // ----- CARDS
            VStack {
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView( value:self.cards[index].value, rule: self.cards[index].rule) {
                           withAnimation {
                               self.removeCard(at: index)
                           }
                        }
                        .stacked(at: index, in: self.cards.count)
                    }
                }
            }
            
        // ----- Tela (zstack)
        }.sheet(isPresented: $showingEditScreen, onDismiss: resetCards) {
            EditCards()
        }
        .onAppear(perform: resetCards)
    }
    func removeCard(at index: Int) {
        cards.remove(at: index)
    }
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = []
                for card in decoded{
                    cards.append(card)
                    cards.append(card)
                    cards.append(card)
                    cards.append(card)
                }
                //self.cards = decoded
            }
        }
    }
    func resetCards() {
        loadData()
        cards.shuffle()
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: offset * 4, height: offset * 2))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
