//
//  LoginView.swift
//  OpenBook
//

import SwiftUI
import ClerkKit
import ClerkKitUI

struct LoginView: View {
    
    @Binding var isLoggedIn: Bool
    @Binding var currentName: String
    
    @State private var showAuth = false
    @State private var showError = false
    @State private var isLoggingIn = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                // Background
                Color(red: 250/255, green: 243/255, blue: 224/255)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    // App Title
                    Text("OpenBook")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 62/255, green: 39/255, blue: 35/255))
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        
                        Text("Login")
                            .font(.largeTitle)
                            .bold()
                        
                        // LOGIN BUTTON ONLY (NO AUTO LOGIN)
                        Button(action: {
                            showAuth = true
                        }) {
                            if isLoggingIn {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                Text("Continue with Clerk")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        }
                        .background(Color(red: 62/255, green: 39/255, blue: 35/255))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .disabled(isLoggingIn)
                        
                        if showError {
                            Text("Authentication failed. Please try again.")
                                .foregroundColor(.red)
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            
            // MARK: AUTH FLOW (MANUAL ONLY)
            .fullScreenCover(isPresented: $showAuth) {
                AuthView()
                    .onDisappear {
                        handleManualLogin()
                    }
            }
        }
    }
    
    // MARK: - MANUAL LOGIN ONLY
    private func handleManualLogin() {
        if let user = Clerk.shared.user {
            
            currentName = user.firstName ?? "User"
            isLoggedIn = true
            showError = false
            
        } else {
            
            // IMPORTANT: do NOT auto-login or fallback
            isLoggedIn = false
            showError = true
        }
    }
}

#Preview {
    LoginView(
        isLoggedIn: .constant(false),
        currentName: .constant("")
    )
    .environment(Clerk.shared)
}
