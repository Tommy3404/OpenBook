//
//  OpenBookApp.swift
//  OpenBook
//
//  Created by Tommy McClure on 2/18/26.
//

import SwiftUI
import ClerkKit 

@main
struct OpenBookApp: App {
    
    @State private var isLoggedIn = false
    @State private var currentName = ""
    
    init() {
        Clerk.configure(
            publishableKey: "pk_test_bHVja3ktZ2FyLTQxLmNsZXJrLmFjY291bnRzLmRldiQ"
        )
        
        // Load saved display name
        let savedName = UserDefaults.standard.string(forKey: "displayName") ?? ""
        _currentName = State(initialValue: savedName)
    }
    
    var body: some Scene {
        WindowGroup {
            
            Group {
                if isLoggedIn {
                    NavigationStack {
                        HomeView(
                            name: $currentName,
                            isLoggedIn: $isLoggedIn,
                            updateName: updateName
                        )
                    }
                } else {
                    LoginView(
                        isLoggedIn: $isLoggedIn,
                        currentName: $currentName
                    )
                }
            }
            .environment(Clerk.shared)
            .preferredColorScheme(.light)
            
            // ✅ Sync login state on launch
            .task {
                await syncLoginState()
            }
        }
    }
    
    // MARK: - Update Display Name
    private func updateName(_ newName: String) {
        currentName = newName
        UserDefaults.standard.set(newName, forKey: "displayName")
    }
    
    // MARK: - Sync Authentication State
    private func syncLoginState() async {
        await MainActor.run {
            if let user = Clerk.shared.user {
                isLoggedIn = true
                
                // Use saved display name if available
                if let savedName = UserDefaults.standard.string(forKey: "displayName"),
                   !savedName.isEmpty {
                    currentName = savedName
                } else {
                    currentName = user.firstName ?? "User"
                }
            } else {
                isLoggedIn = false
                currentName = ""
            }
        }
    }
}
