//
//  SettingsView.swift
//  OpenBook
//
//  Created by Tommy McClure on 3/3/26.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var name: String
    @Binding var isLoggedIn: Bool
    
    @State private var showMenu = false
    @State private var confirmDelete = false
    @State private var showSavedAlert = false
    
    @State private var resetBooksYearly = false
    @State private var newDisplayName = ""
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            
            // Background
            Color(red: 250/255, green: 243/255, blue: 224/255) // #FAF3E0
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
//                    Text("Settings")
//                        .font(.largeTitle)
//                        .bold()
//                        .padding(.top, 20)
                    
                    // Reset Books Section
                    VStack(alignment: .leading, spacing: 10) {
                        Toggle("Reset Books Each Year", isOn: $resetBooksYearly)
                        Text("When enabled, your 'Books Read' and 'Books To Be Read' lists will reset at the start of a new year.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 10)
                    
                    Divider()
                    
                    // Account Info Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Account Information")
                            .font(.title2)
                            .bold()
                        
                        TextField("New Display Name", text: $newDisplayName)
                            .textFieldStyle(.roundedBorder)
                        
                        TextField("Username", text: $username)
                            .textFieldStyle(.roundedBorder)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                        
                        Button(action: {
                            if !newDisplayName.isEmpty {
                                name = newDisplayName
                            }
                            // Save username/password as needed
                            
                            // Show saved alert
                            showSavedAlert = true
                        }) {
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
                    
                    // Delete Account
                    VStack(alignment: .leading, spacing: 10) {
                        Button(action: {
                            confirmDelete = true
                        }) {
                            Text("Delete Account")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.vertical, 10)
                }
                .padding()
            }
            
            // Dropdown Menu
            if showMenu {
                VStack(alignment: .leading, spacing: 15) {
                    NavigationLink(destination: HomeView(name: $name, isLoggedIn: $isLoggedIn)) {
                        Text("Home")
                    }
                    
                    NavigationLink(destination: SearchView(name: $name, isLoggedIn: $isLoggedIn)) {
                        Text("Search")
                    }
                    
                    NavigationLink(destination: ReadTimeTrackerView(name: $name, isLoggedIn: $isLoggedIn)) {
                        Text("Read Time Tracker")
                    }
                    
                    Divider()
                    
                    Button("Logout") {
                        showMenu = false
                        isLoggedIn = false
                    }
                    .foregroundColor(.red)
                }
                .padding()
                .background(Color(red: 250/255, green: 243/255, blue: 224/255))
                .cornerRadius(12)
                .shadow(radius: 5)
                .frame(width: 180)
                .padding(.trailing, 10)
                .padding(.top, 10)
                .zIndex(1)
            }
        }
        
        // Header
        // MARK: Header
        .safeAreaInset(edge: .top) {
            HeaderView(title: "Settings", showMenu: $showMenu, isLoggedIn: $isLoggedIn)
        }
        .navigationBarBackButtonHidden(true)
        
        // Alerts
        .alert("Delete Account?", isPresented: $confirmDelete) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                isLoggedIn = false
            }
        } message: {
            Text("This action cannot be undone.")
        }
        .alert("Changes Saved", isPresented: $showSavedAlert) {
            Button("OK", role: .destructive) {}
        } message: {
            Text("Your display name, username, and/or password have been updated.")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(name: .constant("Tommy"), isLoggedIn: .constant(true))
    }
}
