//
//  SettingsView.swift
//  OpenBook
//

import SwiftUI
import ClerkKit
import ClerkKitUI

struct SettingsView: View {
    
    @Binding var name: String
    @Binding var isLoggedIn: Bool
    
    var updateName: (String) -> Void
    
    @State private var showMenu = false
    @State private var confirmDelete = false
    @State private var showSavedAlert = false
    
    @State private var resetBooksYearly = false
    @State private var newDisplayName = ""
    
    var body: some View {
        
        ZStack {
            
            Color(red: 250/255, green: 243/255, blue: 224/255)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Toggle("Reset Books Each Year", isOn: $resetBooksYearly)
                        
                        Text("When enabled, your 'Books Read' and 'Books To Be Read' lists will reset at the start of a new year.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 10)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("Display Name")
                            .font(.title2)
                            .bold()
                        
                        TextField("New Display Name", text: $newDisplayName)
                            .textFieldStyle(.roundedBorder)
                        
                        Button {
                            let trimmedName = newDisplayName
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                            
                            guard !trimmedName.isEmpty else { return }
                            
                            updateName(trimmedName)
                            name = trimmedName
                            
                            showSavedAlert = true
                            
                        } label: {
                            Text("Save Changes")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.vertical, 10)
                    
                    Divider()
                    
                    Button {
                        confirmDelete = true
                    } label: {
                        Text("Delete Account")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        
        .safeAreaInset(edge: .top) {
            HeaderView(
                title: "Settings",
                currentPage: "Settings",
                showMenu: $showMenu,
                isLoggedIn: $isLoggedIn,
                updateName: updateName
            )
        }
        .navigationBarBackButtonHidden(true)
        
        .alert("Changes have been saved. New name will be displayed on next login.", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) {}
        }
        
        .alert("Delete Account?", isPresented: $confirmDelete) {
            Button("Cancel", role: .cancel) {}
            
            Button("Delete", role: .destructive) {
                Task {
                    do {
                        try await Clerk.shared.user?.delete()
                    } catch {
                        print("Delete failed:", error)
                    }
                    
                    UserDefaults.standard.removeObject(forKey: "ToBeReadList")
                    UserDefaults.standard.removeObject(forKey: "BooksReadList")
                    UserDefaults.standard.removeObject(forKey: "displayName")
                    
                    await MainActor.run {
                        name = "User"
                        isLoggedIn = false
                    }
                }
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(
            name: .constant("User"),
            isLoggedIn: .constant(true),
            updateName: { _ in }   // ✅ REQUIRED
        )
    }
}
