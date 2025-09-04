//
//  BubbleAnimationView.swift
//  BubbleAnimation
//
//  Created by Анна Сазонова on 10.07.2025.
//

import SwiftUI

// Модель данных для пузыря
struct Bubble: Identifiable, Equatable {
    let id = UUID()
    let creationTime: TimeInterval
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var speed: CGFloat
    var opacity: Double
}

// Вью одного пузыря
struct BubbleView: View {
    let bubble: Bubble
    let onTap: () -> Void
    let currentTime: TimeInterval
    
    var body: some View {
        
        let finalY = countYPosition(bubble: bubble, currentTime: currentTime)
        
        Circle()
            .fill(
                // Градиент
            )
            .frame(width: bubble.size, height: bubble.size)
            .position(x: bubble.x, y: finalY)
            .onTapGesture {
                onTap()
            }
    }
}

// Вью с пузырями которые меняют расположение с течением времени
struct BubbleAnimationView: View {
    static var i = 0
    @State private var bubbles: [Bubble] = (0..<25).map { _ in
        generateBubble("initial")
    }
    
    @State private var poppedBubbles: [Bubble] = []
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let currentTime = timeline.date.timeIntervalSinceReferenceDate
            ZStack {
                ForEach(bubbles) { bubble in
                    BubbleView(bubble: bubble, onTap: {
                        if let index = bubbles.firstIndex(of: bubble) {
                            /// Логика удаления пузыря по нажатию
                        }
                    }, currentTime: currentTime)
                }
            }
        }
    }
}

// Функция, которая генерирует пузыри
private func generateBubble(_ creation: String) -> Bubble {
    let topY = creation == "initial" ? 0 : UIScreen.main.bounds.height * (2/3)
    return Bubble(
        /// Генерируем новый пузырь
        )
}

// Функция подсчета позиции по Y
private func countYPosition(bubble: Bubble, currentTime: TimeInterval) -> CGFloat {
    /// Логика изменения позиции
    
    return finalY
}
