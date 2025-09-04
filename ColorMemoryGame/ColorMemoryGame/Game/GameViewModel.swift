import SwiftUI
import UserNotifications

@MainActor
class GameViewModel: ObservableObject {
    @Published var currentColor: Color = .black
    @Published var uniqueColors: Set<Color> = []
    @Published var isPlaying = false
    @Published var timeLeft = 10
    @Published var result: String?
    @Published var gameDuration = 10
    
    let palette: [Color] = [.red, .orange, .yellow, .green, .mint, .teal, .cyan,
                            .blue, .indigo, .purple, .pink, .brown, .gray]
    
    func startGame() {
        uniqueColors.removeAll()
        result = nil
        timeLeft = gameDuration
        isPlaying = true
        
        Task {
            for _ in 0..<gameDuration {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                guard isPlaying else { break }
                if let newColor = palette.randomElement() {
                    currentColor = newColor
                    uniqueColors.insert(newColor)
                    timeLeft -= 1
                }
            }
            
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            currentColor = .black
            isPlaying = false
        }
    }
    
    func checkAnswer(_ answer: String) {
        guard let guess = Int(answer) else { return }
        let correct = uniqueColors.count
        
        if guess == correct {
            result = "✅ Верно! Было \(correct) уникальных цветов."
        } else {
            result = "❌ Ошибка. Было \(correct) уникальных цветов."
        }
    }
    
}
