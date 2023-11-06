//
//  HomeView.swift
//  FlashZilla
//
//  Created by Shah Md Imran Hossain on 5/11/23.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct HomeView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @State private var cards = Array<Card>(repeating: Card.example, count: 10)
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                    }
                }
            }
        }
        
        if differentiateWithoutColor {
            VStack {
                Spacer()
                
                HStack {
                    Image(systemName: "xmark.circle")
                        .padding()
                        .background(.black.opacity(0.7))
                        .clipShape(Circle())
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.circle")
                        .padding()
                        .background(.black.opacity(0.7))
                        .clipShape(Circle())
                }
                .foregroundStyle(.white)
                .font(.largeTitle)
                .padding()
            }
        }
    }
}

extension HomeView {
    func removeCard(at index: Int) {
        cards.remove(at: index)
    }
}

#Preview {
    HomeView()
}
