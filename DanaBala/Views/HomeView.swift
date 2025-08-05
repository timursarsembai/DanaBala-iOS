//
//  HomeView.swift
//  DanaBala
//
//  Created by Timur Sarsembai on 06/08/2025.
//

import SwiftUI

struct HomeView: View {
    let subjects = Subject.allCases
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // App Title
                Text("DanaBala")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 40)
                
                Spacer()
                
                // Subject Cards
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 20),
                    GridItem(.flexible(), spacing: 20)
                ], spacing: 20) {
                    ForEach(subjects) { subject in
                        NavigationLink(destination: SubjectView(subject: subject)) {
                            SubjectCardView(subject: subject)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct SubjectCardView: View {
    let subject: Subject
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: subject.iconName)
                .font(.system(size: 40))
                .foregroundColor(.white)
            
            Text(subject.rawValue)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(width: 140, height: 140)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(subject.color)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    HomeView()
}
