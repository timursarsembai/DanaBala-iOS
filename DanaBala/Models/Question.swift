//
//  Question.swift
//  DanaBala
//
//  Created by Timur Sarsembai on 06/08/2025.
//

import Foundation

struct Question: Identifiable {
    let id = UUID()
    let text: String
    let correctAnswer: String
    let options: [String]
    
    init(text: String, correctAnswer: String, wrongAnswers: [String]) {
        self.text = text
        self.correctAnswer = correctAnswer
        self.options = ([correctAnswer] + wrongAnswers).shuffled()
    }
}

// Генератор вопросов для изучения цифр
struct DigitsQuestionGenerator {
    
    // Функция для преобразования цифры в текст
    static func digitToWord(_ digit: Int) -> String {
        switch digit {
        case 0: return "ноль"
        case 1: return "один"
        case 2: return "два"
        case 3: return "три"
        case 4: return "четыре"
        case 5: return "пять"
        case 6: return "шесть"
        case 7: return "семь"
        case 8: return "восемь"
        case 9: return "девять"
        default: return "\(digit)"
        }
    }
    
    static func generateQuestions() -> [Question] {
        let digits = Array(0...9)
        var questions: [Question] = []
        
        // Создаем список из каждой цифры по 2 раза (10 цифр × 2 = 20 вопросов)
        var digitPool: [Int] = []
        for digit in digits {
            digitPool.append(digit)
            digitPool.append(digit)
        }
        
        // Перемешиваем начальный пул
        digitPool.shuffle()
        
        // Генерируем вопросы, избегая повторения подряд
        var lastDigit: Int? = nil
        
        for _ in 0..<20 {
            var selectedDigit: Int
            var selectedIndex: Int
            
            // Если в пуле остался только один элемент, берем его
            if digitPool.count == 1 {
                selectedIndex = 0
                selectedDigit = digitPool[selectedIndex]
            } else {
                // Ищем цифру, которая отличается от предыдущей
                repeat {
                    selectedIndex = Int.random(in: 0..<digitPool.count)
                    selectedDigit = digitPool[selectedIndex]
                } while selectedDigit == lastDigit && digitPool.count > 1
            }
            
            // Удаляем выбранную цифру из пула
            digitPool.remove(at: selectedIndex)
            
            // Генерируем варианты неправильных ответов
            let wrongDigits = digits.filter { $0 != selectedDigit }.shuffled().prefix(3)
            
            let question = Question(
                text: "Найди цифру \(digitToWord(selectedDigit))",
                correctAnswer: "\(selectedDigit)",
                wrongAnswers: wrongDigits.map { "\($0)" }
            )
            
            questions.append(question)
            lastDigit = selectedDigit
        }
        
        return questions
    }
}
