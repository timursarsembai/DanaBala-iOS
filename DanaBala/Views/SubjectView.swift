//
//  SubjectView.swift
//  DanaBala
//
//  Created by Timur Sarsembai on 06/08/2025.
//

import SwiftUI

struct SubjectView: View {
    let subject: Subject
    
    // Тренировки для каждого предмета
    var exercises: [Exercise] {
        switch subject {
        case .math:
            return [
                Exercise(title: "Цифры", description: "Изучение цифр от 0 до 9", subject: .math, difficulty: .easy, iconName: "1.circle.fill"),
                Exercise(title: "Счет до 10", description: "Учимся считать от 1 до 10", subject: .math, difficulty: .easy, iconName: "plus.circle.fill"),
                Exercise(title: "Сложение", description: "Простые примеры на сложение", subject: .math, difficulty: .easy, iconName: "equal.circle.fill"),
                Exercise(title: "Вычитание", description: "Простые примеры на вычитание", subject: .math, difficulty: .medium, iconName: "minus.circle.fill"),
                Exercise(title: "Геометрия", description: "Изучаем фигуры", subject: .math, difficulty: .medium, iconName: "triangle.fill"),
                Exercise(title: "Сравнение", description: "Больше, меньше, равно", subject: .math, difficulty: .easy, iconName: "greaterthan.circle.fill")
            ]
        case .reading:
            return [
                Exercise(title: "Алфавит", description: "Изучаем буквы", subject: .reading, difficulty: .easy, iconName: "a.circle.fill"),
                Exercise(title: "Слоги", description: "Читаем по слогам", subject: .reading, difficulty: .easy, iconName: "textformat.abc"),
                Exercise(title: "Слова", description: "Простые слова", subject: .reading, difficulty: .medium, iconName: "text.word.spacing"),
                Exercise(title: "Предложения", description: "Читаем предложения", subject: .reading, difficulty: .medium, iconName: "text.alignleft"),
                Exercise(title: "Сказки", description: "Короткие сказки", subject: .reading, difficulty: .hard, iconName: "book.closed.fill"),
                Exercise(title: "Стихи", description: "Детские стихотворения", subject: .reading, difficulty: .hard, iconName: "music.note")
            ]
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text(subject.rawValue)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                // Exercise Cards Grid
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 15),
                    GridItem(.flexible(), spacing: 15)
                ], spacing: 15) {
                    ForEach(exercises) { exercise in
                        NavigationLink(destination: QuizView(exercise: exercise)) {
                            ExerciseCardView(exercise: exercise)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer(minLength: 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExerciseCardView: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon
            Image(systemName: exercise.iconName)
                .font(.system(size: 30))
                .foregroundColor(.white)
            
            // Title
            Text(exercise.title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            // Difficulty indicator
            Text(exercise.difficulty.rawValue)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .frame(width: 160, height: 160)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(exercise.subject.color)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    NavigationStack {
        SubjectView(subject: .math)
    }
}
