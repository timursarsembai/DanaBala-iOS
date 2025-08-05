//
//  Exercise.swift
//  DanaBala
//
//  Created by Timur Sarsembai on 06/08/2025.
//

import Foundation

struct Exercise: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let subject: Subject
    let difficulty: Difficulty
    let iconName: String
}

enum Difficulty: String, CaseIterable {
    case easy = "Легко"
    case medium = "Средне"
    case hard = "Сложно"
    
    var color: String {
        switch self {
        case .easy:
            return "green"
        case .medium:
            return "orange"
        case .hard:
            return "red"
        }
    }
}