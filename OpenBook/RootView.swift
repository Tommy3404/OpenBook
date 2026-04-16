//
//  RootView.swift
//  OpenBook
//

import SwiftUI

struct RootView: View {
    
    @State private var isLoggedIn: Bool = false
    @State private var name: String = ""
    
    var body: some View {
        NavigationStack {
            if isLoggedIn {
                HomeView(
                    name: $name,
                    isLoggedIn: $isLoggedIn,
                    updateName: updateName   // ✅ FIX ADDED
                )
            } else {
                LoginView(
                    isLoggedIn: $isLoggedIn,
                    currentName: $name
                )
            }
        }
    }
    
    // ✅ CRITICAL: this connects EVERYTHING
    private func updateName(_ newName: String) {
        name = newName
        UserDefaults.standard.set(newName, forKey: "displayName")
    }
}
