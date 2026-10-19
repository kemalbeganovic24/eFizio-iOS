//
//  ThemeToggleButton.swift
//  eFizio
//

import SwiftUI

struct ThemeToggleButton: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                isDarkMode.toggle()
            }
        }) {
            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(isDarkMode ? .yellow : .white)
                .padding(10)
                .background(
                    Circle()
                        .fill(isDarkMode ? Color.white.opacity(0.15) : Color.white.opacity(0.2))
                )
        }
    }
}
