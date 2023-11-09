//
//  CardView.swift
//  FlashZilla
//
//  Created by Shah Md Imran Hossain on 5/11/23.
//

import SwiftUI

struct CardView: View {
    let card: Card
    var removal: (() -> Void)? = nil
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .fill(
                    differentiateWithoutColor 
                    ? .white
                    : .white.opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                        .fill(offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)
            
            VStack {
                if voiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        // order of modifiers matters
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged{ gesture in
//                    withAnimation {
//                        offset = gesture.translation
//                    }
                    
                    offset = gesture.translation
                    feedback.prepare()
                }
                .onEnded{ _ in
                    if abs(offset.width) > 100 {
                        // feedback
                        if offset.width > 0 {
                            // commenting out cause too much haptic is bad
//                            feedback.notificationOccurred(.success)
                        } else {
                            feedback.notificationOccurred(.error)
                        }
                        
                        // remove the card
                        removal?()
                    } else {
//                        withAnimation {
//                            offset = .zero
//                        }
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.spring(), value: offset)
    }
}

#Preview {
    CardView(card: Card.example)
}
