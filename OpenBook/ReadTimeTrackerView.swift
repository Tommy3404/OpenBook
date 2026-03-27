//
//  ReadTimeTrackerView.swift
//  OpenBook
//
//  Created by Tommy McClure on 3/3/26.
//

import SwiftUI

struct ReadTimeTrackerView: View {
    
    @Binding var name: String
    @Binding var isLoggedIn: Bool
    
    @State private var showMenu = false
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            
            Color(red: 250/255, green: 243/255, blue: 224/255)
                    .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Read Time Tracker Page")
                    .font(.title2)
                
                Spacer()
            }
            
            
            if showMenu {
                VStack(alignment: .leading, spacing: 15) {
                    
                    NavigationLink(destination: HomeView(name: $name, isLoggedIn: $isLoggedIn)) {
                        Text("Home")
                    }
                    .simultaneousGesture(TapGesture().onEnded { showMenu = false })
                    
                    NavigationLink(destination: SearchView(name: $name, isLoggedIn: $isLoggedIn)) {
                        Text("Search")
                    }
                    .simultaneousGesture(TapGesture().onEnded { showMenu = false })
                    
                    NavigationLink(destination: SettingsView(name: $name, isLoggedIn: $isLoggedIn)) {
                        Text("Settings")
                    }
                    .simultaneousGesture(TapGesture().onEnded { showMenu = false })
                    
                    Divider()
                    
                    Button("Logout") {
                        showMenu = false
                        isLoggedIn = false
                    }
                    .foregroundColor(.red)
                }
                .padding()
                .background(Color(red: 235/255, green: 213/255, blue: 195/255))
                .cornerRadius(12)
                .shadow(radius: 5)
                .frame(width: 190)
                .padding(.trailing, 10)
                .padding(.top, 10)
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(1)
            }
        }
        
        // Header
        .safeAreaInset(edge: .top) {
            HeaderView(title: "Read Time Tracker", showMenu: $showMenu, isLoggedIn: $isLoggedIn)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        ReadTimeTrackerView(name: .constant("Tommy"),
                   isLoggedIn: .constant(true))
    }
}
