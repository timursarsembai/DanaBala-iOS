//
//  Subject.swift
//  DanaBala
//
//  Created by Timur Sarsembai on 06/08/2025.
//

import Foundation
import SwiftUI

enum Subject: String, CaseIterable, Identifiable {
    case math = "Математика"
    case reading = "Чтение"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .math:
            return "function"
        case .reading:
            return "book.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .math:
            return .blue
        case .reading:
            return .green
        }
    }
}
