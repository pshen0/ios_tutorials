//
//  ContentView.swift
//  BubbleAnimation
//
//  Created by Анна Сазонова on 10.07.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            MainBGGradient()
            BubbleAnimationView()
        }
    }
}

#Preview {
    ContentView()
}
