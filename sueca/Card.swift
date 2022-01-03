//
//  Card.swift
//  sueca
//
//  Created by Daniela Palumbo on 15/09/21.
//

import Foundation
import SwiftUI

struct Card: Codable {
    var value: String
    var rule: String
}

struct CardView : View{
    @State private var offset = CGSize.zero
    let value: String
    let rule: String
    var removal: (() -> Void)? = nil
    var body: some View {
    ZStack {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color.white).shadow(radius: 10)

                VStack {
                    Text(value)
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text(rule)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
                .padding(20)
                .multilineTextAlignment(.center)
            }
            .frame(width: 250, height: 450)
    .rotationEffect(.degrees(Double(offset.width / 5)))
    .offset(x: offset.width * 5, y: 0)
    .opacity(2 - Double(abs(offset.width / 50)))
    .gesture(
        DragGesture()
            .onChanged { gesture in
                self.offset = gesture.translation
            }

            .onEnded { _ in
                if abs(self.offset.width) > 100 {
                    // remove the card
                    self.removal?()

                } else {
                    self.offset = .zero
                }
            }
    )
    }
}
