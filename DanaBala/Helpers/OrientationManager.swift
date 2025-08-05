//
//  OrientationManager.swift
//  DanaBala
//
//  Created by Timur Sarsembai on 06/08/2025.
//

import SwiftUI

struct OrientationLockModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                // Lock orientation to portrait
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
                }
            }
    }
}

extension View {
    func lockOrientation() -> some View {
        self.modifier(OrientationLockModifier())
    }
}