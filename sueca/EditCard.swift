//
//  EditCard.swift
//  sueca
//
//  Created by Daniela Palumbo on 16/09/21.
//

import Foundation
import SwiftUI
struct EditCards: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cards = [Card]()
    @State private var newValue = ""
    @State private var newRule = ""
    @State private var cartasValidas = [String]()
    

    var body: some View {
        
        NavigationView {
            List {
                Section(header: Text("Add new card")) {
                    Picker("Card value:", selection: $newValue) {
                        ForEach(cartasValidas, id: \.self) {
                                Text($0)
                        }
                    }
                    TextField("Rule", text: $newRule)
                    Button("Add card", action: addCard)
                }

                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(self.cards[index].value)
                                .font(.headline)
                            Text(self.cards[index].rule)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
                Button("Limpar regras", action: resetCards)
            }
            .navigationBarTitle("Edit Cards")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
            .listStyle(GroupedListStyle())
            .onAppear(perform: loadData)
            
        }
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }
        if let data = UserDefaults.standard.data(forKey: "Valid Cards") {
            if let decoded = try? JSONDecoder().decode([String].self, from: data) {
                self.cartasValidas = decoded
            }
        } else {
            self.cartasValidas = ["4","5","6","7","8","9","10"]
        }
    }

    func saveData() {
        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: "Cards")
        }
        if let data = try? JSONEncoder().encode(cartasValidas) {
            UserDefaults.standard.set(data, forKey: "Valid Cards")
        }
    }

    func addCard() {
        let trimmedValue = newValue.trimmingCharacters(in: .whitespaces)
        let trimmedRule = newRule.trimmingCharacters(in: .whitespaces)
        guard trimmedValue.isEmpty == false && trimmedRule.isEmpty == false else { return }

        let card = Card(value: trimmedValue, rule: trimmedRule)
        cards.append(card)
        cartasValidas.remove(at:cartasValidas.firstIndex(of:trimmedValue)!)
        saveData()
    }

    func removeCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        saveData()
    }
    func resetCards() {
        self.cartasValidas = ["4","5","6","7","8","9","10"]
        self.cards = []
        saveData()
    }
}
