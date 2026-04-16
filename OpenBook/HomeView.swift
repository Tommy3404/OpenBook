//
//  HomeView.swift
//  OpenBook
//

import SwiftUI
import ClerkKit

struct HomeView: View {
    
    @Binding var name: String
    @Binding var isLoggedIn: Bool
    
    var updateName: (String) -> Void
    
    @State private var showMenu = false
    @State private var booksRead: [Book] = []
    @State private var booksToRead: [Book] = []
    
    private let backgroundColor = Color(red: 250/255, green: 243/255, blue: 224/255)
    private let sectionColor = Color(red: 235/255, green: 213/255, blue: 195/255)
    
    private let allBooks: [Book] = [
        Book(title: "To Kill a Mockingbird", rating: 4.8, coverImage: "mockingbird"),
        Book(title: "Ready Player One", rating: 4.6, coverImage: "ReadyPlayerOne"),
        Book(title: "The Great Gatsby", rating: 4.4, coverImage: "GreatGatsby"),
        Book(title: "IT", rating: 4.5, coverImage: "IT")
    ]
    
    var body: some View {
        
        ZStack {
            
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Text("Welcome, \(displayName)!")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity)
                
                ScrollView {
                    VStack(spacing: 30) {
                        
                        sectionView(
                            title: "Books Read",
                            books: booksRead,
                            destination: BooksReadView()
                        )
                        
                        sectionView(
                            title: "Books To Be Read",
                            books: booksToRead,
                            destination: BooksToBeReadView()
                        )
                    }
                    .padding()
                }
                
                Spacer()
            }
        }
        
        .safeAreaInset(edge: .top) {
            HeaderView(
                title: "OpenBook",
                currentPage: "Home",
                showMenu: $showMenu,
                isLoggedIn: $isLoggedIn,
                updateName: updateName
            )
        }
        .navigationBarBackButtonHidden(true)
        
        .onAppear {
            loadBooks()
            name = UserDefaults.standard.string(forKey: "displayName") ?? "User"
        }
    }
    
    private var displayName: String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "User" : trimmed
    }
    
    private func sectionView<Destination: View>(
        title: String,
        books: [Book],
        destination: Destination
    ) -> some View {
        
        VStack(spacing: 0) {
            
            HStack {
                Text(title)
                    .font(.title2)
                    .bold()
                    .underline()
                
                Spacer()
                
                NavigationLink(destination: destination) {
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    
                    if books.isEmpty {
                        Text("No books yet")
                            .foregroundColor(.gray)
                            .padding(.leading)
                    } else {
                        ForEach(books) {
                            Image($0.coverImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 110)
                                .cornerRadius(8)
                                .shadow(radius: 3)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 140)
        }
        .background(sectionColor)
        .cornerRadius(12)
    }
    
    private func loadBooks() {
        let readTitles = UserDefaults.standard.stringArray(forKey: "BooksReadList") ?? []
        let tbrTitles = UserDefaults.standard.stringArray(forKey: "ToBeReadList") ?? []
        
        booksRead = allBooks.filter { readTitles.contains($0.title) }
        booksToRead = allBooks.filter { tbrTitles.contains($0.title) }
    }
}

#Preview {
    NavigationStack {
        HomeView(
            name: .constant("User"),
            isLoggedIn: .constant(true),
            updateName: { _ in }
        )
    }
}
