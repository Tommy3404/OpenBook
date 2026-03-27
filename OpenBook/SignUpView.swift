//
//  SignUpView.swift
//  OpenBook
//
//  Created by Tommy McClure on 2/23/26.
//

import SwiftUI

struct SignUpView: View {
    
    @Binding var users: [String: (name: String, password: String)]
    
    @State private var name = ""
    @State private var newUsername = ""
    @State private var newPassword = ""
    @State private var showMessage = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
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
                    
                    Text("Create Account")
                        .font(.largeTitle)
                        .bold()
                    
                    TextField("Display Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Username", text: $newUsername)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    SecureField("Password", text: $newPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button("Create Account") {
                        createAccount()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    if showMessage {
                        Text("Account created! You can now log in.")
                            .foregroundColor(.green)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    func createAccount() {
        guard !name.isEmpty,
              !newUsername.isEmpty,
              !newPassword.isEmpty else { return }
        
        users[newUsername] = (name: name, password: newPassword)
        showMessage = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
}

#Preview {
    SignUpView(users: .constant([:]))
}
