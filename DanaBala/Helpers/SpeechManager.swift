//
//  SpeechManager.swift
//  DanaBala
//
//  Created by Timur Sarsembai on 06/08/2025.
//

import AVFoundation
import SwiftUI

class SpeechManager: ObservableObject {
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    func speak(_ text: String, rate: Float = 0.5) {
        // Останавливаем предыдущее озвучивание
        speechSynthesizer.stopSpeaking(at: .immediate)
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
        utterance.rate = rate
        utterance.volume = 1.0
        
        speechSynthesizer.speak(utterance)
    }
    
    func speakCorrectAnswer() {
        speak("Молодец!")
    }
    
    func speakIncorrectAnswer() {
        speak("Попробуй еще раз")
    }
    
    func stopSpeaking() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
}