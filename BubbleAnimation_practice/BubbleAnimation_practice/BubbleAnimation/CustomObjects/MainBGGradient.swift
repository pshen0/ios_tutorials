//
//  MainRGBGradient.swift
//  BubbleAnimation
//
//  Created by Анна Сазонова on 10.07.2025.
//

import SwiftUI

struct MainBGGradient: View {
    var body: some View {
        LinearGradient (
            gradient: Gradient(stops: [
                .init(color: Color.highlightedBackground, location: 0.6),
                .init(color: Color.background, location: 0.9),
            ]),
            startPoint: .top,
            endPoint: .bottom
        ).ignoresSafeArea()
    }
}
