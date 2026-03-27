//
//  HomeView.swift
//  OpenBook
//
//  Created by Tommy McClure on 2/23/26.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var name: String
    @Binding var isLoggedIn: Bool
    
    @State private var showMenu = false
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            
            // App background
            Color(red: 250/255, green: 243/255, blue: 224/255) // #FAF3E0
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                // Welcome text
                Text("Welcome, \(name)!")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity)
                
                ScrollView {
                    VStack(spacing: 30) {
                        
                        // MARK: - Books Read Section
                        VStack(spacing: 0) {
                            HStack {
                                Text("Books Read")
                                    .font(.title2)
                                    .bold()
                                    .underline()
                                
                                Spacer()
                                
                                NavigationLink(destination: BooksReadView()) {
                                    Text("View All")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.brown)
                                        .cornerRadius(6)
                                }
                            }
                            .padding()
                            
                            // Placeholder for book covers
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    // Empty for now
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 150)
                        }
                        .background(Color(red: 235/255, green: 213/255, blue: 195/255)) // #EBD5C3
                        .cornerRadius(12)
                        
                        // MARK: - Books To Be Read Section
                        VStack(spacing: 0) {
                            HStack {
                                Text("Books To Be Read")
                                    .font(.title2)
                                    .bold()
                                    .underline()
                                
                                Spacer()
                                
                                NavigationLink(destination: BooksToBeReadView()) {
                                    Text("View All")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.brown)
                                        .cornerRadius(6)
                                }
                            }
                            .padding()
                            
                            // Placeholder for book covers
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    // Empty for now
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 150)
                        }
                        .background(Color(red: 235/255, green: 213/255, blue: 195/255)) // #EBD5C3
                        .cornerRadius(12)
                        
                    }
                    .padding()
                }
                
                Spacer()
            }
            
            // MARK: Dropdown Menu
            if showMenu {
                VStack(alignment: .leading, spacing: 15) {
                    
                    NavigationLink(destination: SearchView(name: $name, isLoggedIn: $isLoggedIn)) {
                        Text("Search")
                    }
                    
                    NavigationLink(destination: SettingsView(name: $name, isLoggedIn: $isLoggedIn)) {
                        Text("Settings")
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
                .background(Color(red: 250/255, green: 243/255, blue: 224/255)) // #FAF3E0
                .cornerRadius(12)
                .shadow(radius: 5)
                .frame(width: 180)
                .padding(.trailing, 10)
                .padding(.top, 10)
                .zIndex(1)
            }
        }
        
        
        // MARK: Header
        .safeAreaInset(edge: .top) {
            HeaderView(title: "OpenBook", showMenu: $showMenu, isLoggedIn: $isLoggedIn)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        HomeView(name: .constant("Tommy"), isLoggedIn: .constant(true))
    }
}
