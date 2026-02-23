//
//  HomeView.swift
//  OpenBook
//
//  Created by Tommy McClure on 2/23/26.
//

import SwiftUI

struct HomeView: View {
    var name: String
    @Binding var isLoggedIn: Bool
    
    @State private var showMenu = false
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            
            // Background
            Color(
                red: 250/255,
                green: 243/255,
                blue: 224/255
            )
            .ignoresSafeArea()
            
            VStack {
                
                // Welcome Text closer to header
                Text("Welcome, \(name)!")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20) // small padding below header
                    .frame(maxWidth: .infinity)
                
                Spacer() // keeps it centered vertically for the rest
                
            }
            
            // Dropdown Menu
            if showMenu {
                VStack(alignment: .leading, spacing: 15) {
                    
                    Button("Search") {
                        showMenu = false
                        print("Search tapped")
                    }
                    
                    Button("Settings") {
                        showMenu = false
                        print("Settings tapped")
                    }
                    
                    Divider()
                    
                    Button("Logout") {
                        showMenu = false
                        isLoggedIn = false
                    }
                    .foregroundColor(.red)
                    
                }
                .padding()
                .background(Color(
                    red: 235/255,
                    green: 213/255,
                    blue: 195/255
                ))
                .cornerRadius(12)
                .shadow(radius: 5)
                .frame(width: 150)
                .padding(.trailing, 10)
                .padding(.top, 10) // right under hamburger
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(1)
            }
        }
        
        // Header
        .safeAreaInset(edge: .top) {
            HStack {
                
                Text("OpenBook")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                
                Spacer()
                
                Button {
                    withAnimation(.spring()) {
                        showMenu.toggle()
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color(
                red: 62.0/255.0,
                green: 39.0/255.0,
                blue: 35.0/255.0))
        }
        
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView(name: "Tommy",
             isLoggedIn: .constant(true))
}
