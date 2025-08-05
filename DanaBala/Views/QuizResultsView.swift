//
//  QuizResultsView.swift
//  DanaBala
//
//  Created by Timur Sarsembai on 06/08/2025.
//

import SwiftUI

struct QuizResultsView: View {
    let totalQuestions: Int
    let correctAnswers: Int  // Правильные ответы с первой попытки
    let onRestart: () -> Void
    let onExit: () -> Void
    
    var percentage: Int {
        guard totalQuestions > 0 else { return 0 }
        return Int(Double(correctAnswers) / Double(totalQuestions) * 100)
    }
    
    var resultMessage: String {
        switch percentage {
        case 90...100:
            return "Отлично! 🌟"
        case 70..<90:
            return "Хорошо! 👍"
        case 50..<70:
            return "Неплохо! 😊"
        default:
            return "Попробуй еще раз! 💪"
        }
    }
    
    var resultColor: Color {
        switch percentage {
        case 90...100:
            return .green
        case 70..<90:
            return .blue
        case 50..<70:
            return .orange
        default:
            return .red
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Result message
            Text(resultMessage)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(resultColor)
            
            // Score circle
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                    .frame(width: 150, height: 150)
                
                Circle()
                    .trim(from: 0, to: Double(percentage) / 100)
                    .stroke(resultColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: percentage)
                
                VStack {
                    Text("\(percentage)%")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(resultColor)
                    
                    Text("\(correctAnswers)/\(totalQuestions)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // Detailed stats
            VStack(spacing: 10) {
                Text("Статистика:")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack {
                    VStack {
                        Text("\(correctAnswers)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        Text("Правильно")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("с первой попытки")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("\(totalQuestions - correctAnswers)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        Text("С ошибками")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("или со второй попытки")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 40)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
            )
            
            // Buttons
            VStack(spacing: 15) {
                Button("Попробовать еще раз") {
                    onRestart()
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button("Вернуться к тренировкам") {
                    onExit()
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.blue)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    QuizResultsView(
        totalQuestions: 20,
        correctAnswers: 16,
        onRestart: {},
        onExit: {}
    )
}
