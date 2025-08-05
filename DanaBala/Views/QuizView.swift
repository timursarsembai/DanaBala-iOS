//
//  QuizView.swift
//  DanaBala
//
//  Created by Timur Sarsembai on 06/08/2025.
//

import SwiftUI

struct QuizView: View {
    let exercise: Exercise
    @State private var questions: [Question] = []
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String? = nil
    @State private var wrongAnswers: Set<String> = []
    @State private var showingResults = false
    @State private var correctFirstTryCount = 0
    @State private var hasAnsweredIncorrectly = false
    @StateObject private var speechManager = SpeechManager()
    @Environment(\.dismiss) private var dismiss
    
    var currentQuestion: Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    var body: some View {
        VStack(spacing: 30) {
            // Header with progress
            HStack {
                Button("Назад") {
                    speechManager.stopSpeaking()
                    dismiss()
                }
                .foregroundColor(.blue)
                
                Spacer()
                
                Text("\(currentQuestionIndex + 1)/\(questions.count)")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            // Progress bar
            ProgressView(value: Double(currentQuestionIndex), total: Double(questions.count))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .padding(.horizontal)
            
            Spacer()
            
            if let question = currentQuestion {
                // Question text
                Text(question.text)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Speaker button under question
                Button(action: {
                    speechManager.speak(question.text)
                }) {
                    Image(systemName: "speaker.2.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.1))
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 10)
                
                Spacer()
                
                // Answer options in 2x2 grid
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 20),
                    GridItem(.flexible(), spacing: 20)
                ], spacing: 20) {
                    ForEach(question.options, id: \.self) { option in
                        AnswerButton(
                            text: option,
                            isSelected: selectedAnswer == option,
                            isCorrect: option == question.correctAnswer,
                            isWrong: wrongAnswers.contains(option),
                            hasAnswered: selectedAnswer != nil
                        ) {
                            handleAnswerSelection(option)
                        }
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadQuestions()
        }
        .onChange(of: currentQuestionIndex) { _, _ in
            // Озвучиваем новый вопрос с небольшой задержкой
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let question = currentQuestion {
                    speechManager.speak(question.text)
                }
            }
        }
        .sheet(isPresented: $showingResults) {
            QuizResultsView(
                totalQuestions: questions.count,
                correctAnswers: correctFirstTryCount,
                onRestart: restartQuiz,
                onExit: { dismiss() }
            )
        }
    }
    
    private func loadQuestions() {
        if exercise.title == "Цифры" {
            questions = DigitsQuestionGenerator.generateQuestions()
        }
        
        // Озвучиваем первый вопрос
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let question = currentQuestion {
                speechManager.speak(question.text)
            }
        }
    }
    
    private func handleAnswerSelection(_ answer: String) {
        guard let question = currentQuestion else { return }
        
        if answer == question.correctAnswer {
            // Правильный ответ
            selectedAnswer = answer
            
            // Засчитываем правильный ответ только если не было ошибок на этом вопросе
            if !hasAnsweredIncorrectly {
                correctFirstTryCount += 1
            }
            
            // Озвучиваем похвалу
            speechManager.speakCorrectAnswer()
            
            // Переход к следующему вопросу через 2 секунды
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                moveToNextQuestion()
            }
        } else {
            // Неправильный ответ
            wrongAnswers.insert(answer)
            hasAnsweredIncorrectly = true
            
            // Озвучиваем подсказку
            speechManager.speakIncorrectAnswer()
        }
    }
    
    private func moveToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswer = nil
            wrongAnswers.removeAll()
            hasAnsweredIncorrectly = false
        } else {
            // Тренировка завершена
            showingResults = true
        }
    }
    
    private func restartQuiz() {
        currentQuestionIndex = 0
        selectedAnswer = nil
        wrongAnswers.removeAll()
        correctFirstTryCount = 0
        hasAnsweredIncorrectly = false
        loadQuestions()
        showingResults = false
    }
}

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isWrong: Bool
    let hasAnswered: Bool
    let action: () -> Void
    
    var backgroundColor: Color {
        if isWrong {
            return .red
        } else if isSelected && isCorrect {
            return .green
        } else {
            return .blue
        }
    }
    
    var body: some View {
        Button(action: {
            if !hasAnswered {
                action()
            }
        }) {
            Text(text)
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 120, height: 120)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(backgroundColor)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                )
        }
        .disabled(hasAnswered)
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

#Preview {
    QuizView(exercise: Exercise(
        title: "Цифры",
        description: "Изучение цифр от 0 до 9",
        subject: .math,
        difficulty: .easy,
        iconName: "1.circle.fill"
    ))
}
