//
//  HeaderView.swift
//  OpenBook
//

import SwiftUI
import ClerkKit

struct HeaderView: View {
    
    var title: String
    var currentPage: String
    @Binding var showMenu: Bool
    @Binding var isLoggedIn: Bool
    
    // ✅ REQUIRED
    var updateName: (String) -> Void
    
    var body: some View {
        
        ZStack {
            
            HStack {
                
                Text(title)
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
            .background(Color(red: 62/255, green: 39/255, blue: 35/255))
        }
        .overlay(alignment: .topTrailing) {
            
            if showMenu {
                
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                    }
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    if currentPage != "Home" {
                        NavigationLink(destination: HomeView(
                            name: .constant(""),
                            isLoggedIn: $isLoggedIn,
                            updateName: updateName
                        )) {
                            Text("Home")
                        }
                    }
                    
                    if currentPage != "Search" {
                        NavigationLink(destination: SearchView(
                            name: .constant(""),
                            isLoggedIn: $isLoggedIn,
                            updateName: updateName
                        )) {
                            Text("Search")
                        }
                    }
                    
                    if currentPage != "Settings" {
                        NavigationLink(destination: SettingsView(
                            name: .constant(""),
                            isLoggedIn: $isLoggedIn,
                            updateName: updateName
                        )) {
                            Text("Settings")
                        }
                    }
                    
                    if currentPage != "Tracker" {
                        NavigationLink(destination: ReadTimeTrackerView(
                            name: .constant(""),
                            isLoggedIn: $isLoggedIn,
                            updateName: updateName
                        )) {
                            Text("Read Time Tracker")
                        }
                    }
                    
                    Divider()
                    
                    Button {
                        Task {
                            try? await Clerk.shared.auth.signOut()
                            
                            await MainActor.run {
                                isLoggedIn = false
                                showMenu = false
                            }
                        }
                    } label: {
                        Text("Logout")
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .background(
                    Color(red: 235/255, green: 213/255, blue: 195/255)
                        .opacity(0.78)
                        .overlay(.ultraThinMaterial.opacity(0.35))
                )
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black.opacity(0.4), lineWidth: 1)
                )
                .frame(width: 190)
                .padding(.trailing, 10)
                .padding(.top, 70)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .zIndex(999)
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var showMenu = false
        @State var isLoggedIn = true
        
        var body: some View {
            HeaderView(
                title: "Header",
                currentPage: "Home",
                showMenu: $showMenu,
                isLoggedIn: $isLoggedIn,
                updateName: { _ in }   // ✅ REQUIRED
            )
        }
    }
    
    return PreviewWrapper()
}
