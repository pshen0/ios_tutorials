import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var answer = ""
    @FocusState private var answerFieldFocused: Bool
    
    var body: some View {
        ZStack {
            viewModel.currentColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Text("Color Memory Game")
                        .font(.title2).bold()
                        .foregroundColor(.white)
                    Spacer()
                    if viewModel.isPlaying {
                        Text("\(viewModel.timeLeft)s")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                
                if !viewModel.isPlaying {
                    VStack(spacing: 15) {
                        HStack {
                            Text("Время игры:")
                                .foregroundColor(.white)
                            Stepper("\(viewModel.gameDuration) сек",
                                    value: $viewModel.gameDuration,
                                    in: 5...30)
                        }
                        .padding(.horizontal)
                        
                        TextField("Сколько уникальных цветов?", text: $answer)
                            .keyboardType(.numberPad)
                            .focused($answerFieldFocused)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        Button("Проверить") {
                            viewModel.checkAnswer(answer)
                            answerFieldFocused = false
                        }
                        .buttonStyle(.borderedProminent)
                        
                        if let result = viewModel.result {
                            Text(result)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                }
                
                Spacer()
                
                Button(viewModel.isPlaying ? "Идёт игра..." : "Начать игру") {
                    answer = ""
                    viewModel.startGame()
                }
                .disabled(viewModel.isPlaying)
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}
