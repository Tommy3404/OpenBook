//
//  LoginView.swift
//  OpenBook
//
//  Created by Tommy McClure on 2/23/26.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var isLoggedIn: Bool
    @Binding var currentName: String
    
    @State private var username = ""
    @State private var password = ""
    @State private var showError = false
    
    @State private var users: [String: (name: String, password: String)] = [:]
    
    var body: some View {
        
        NavigationStack {   // 👈 ADD THIS
            
            ZStack {
                
                Color(
                    red: 250/255,
                    green: 243/255,
                    blue: 224/255
                )
                .ignoresSafeArea()
                
                VStack {
                    
                    Text("OpenBook")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(
                            red: 62.0/255.0,
                            green: 39.0/255.0,
                            blue: 35.0/255.0))
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        
                        Text("Login")
                            .font(.largeTitle)
                            .bold()
                        
                        TextField("Username", text: $username)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        Button("Login") {
                            loginUser()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(
                            red: 62.0/255.0,
                            green: 39.0/255.0,
                            blue: 35.0/255.0))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        if showError {
                            Text("Invalid username or password")
                                .foregroundColor(.red)
                        }
                        
                        NavigationLink("Don't have an account? Sign Up") {
                            SignUpView(users: $users)
                        }
                        .padding(.top)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)   // optional, keeps it clean
        }
    
    }
    
    func loginUser() {
        if let user = users[username],
           user.password == password {
            
            currentName = user.name   // ✅ pass name upward
            isLoggedIn = true         // ✅ switch root view
            showError = false
            
        } else {
            showError = true
        }
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false),
              currentName: .constant(""))
}
