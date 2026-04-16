//
//  BooksToBeReadView.swift
//  OpenBook
//

import SwiftUI

struct BooksToBeReadView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var savedBooks: [Book] = []
    @State private var selectedBook: Book? = nil
    @State private var showActionSheet = false
    
    // MARK: - Theme
    private let backgroundColor = Color(red: 250/255, green: 243/255, blue: 224/255)
    private let headerColor = Color(red: 62/255, green: 39/255, blue: 35/255)
    
    // MARK: - Source of truth (ONLY used for matching saved titles)
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
            
            VStack {
                
                // MARK: - Empty State (TRUE EMPTY)
                if savedBooks.isEmpty {
                    Spacer()
                    
                    Text("No books added yet.")
                        .font(.title3)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                
                // MARK: - Book List
                else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            
                            ForEach(savedBooks) { book in
                                
                                HStack(spacing: 15) {
                                    
                                    Image(book.coverImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 90)
                                        .cornerRadius(8)
                                        .shadow(radius: 2)
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(book.title)
                                            .font(.headline)
                                            .foregroundColor(Color(red: 166/255, green: 124/255, blue: 82/255))
                                        
                                        HStack {
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                            
                                            Text(String(format: "%.1f / 5", book.rating))
                                                .foregroundColor(.gray)
                                                .font(.subheadline)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 2)
                                .padding(.horizontal)
                                
                                // Tap actions
                                .onTapGesture {
                                    selectedBook = book
                                    showActionSheet = true
                                }
                            }
                        }
                        .padding(.top)
                    }
                }
            }
        }
        
        // MARK: HEADER (unchanged)
        .safeAreaInset(edge: .top) {
            HStack {
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("Books To Be Read")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                
                Spacer()
                
                Image(systemName: "arrow.left")
                    .opacity(0)
            }
            .padding()
            .background(headerColor)
        }
        .navigationBarBackButtonHidden(true)
        
        // MARK: LOAD DATA (NO PRE-FILLING)
        .onAppear {
            loadBooks()
        }
        
        // MARK: ACTION SHEET
        .confirmationDialog(
            "What would you like to do?",
            isPresented: $showActionSheet,
            titleVisibility: .visible
        ) {
            
            Button("Move to Books Read") {
                if let book = selectedBook {
                    moveToRead(book)
                }
            }
            
            Button("Remove from List", role: .destructive) {
                if let book = selectedBook {
                    removeFromTBR(book)
                }
            }
            
            Button("Cancel", role: .cancel) {}
        }
    }
    
    // MARK: - LOAD (TRUE EMPTY SAFE VERSION)
    private func loadBooks() {
        let savedTitles = UserDefaults.standard.stringArray(forKey: "ToBeReadList") ?? []
        
        // IMPORTANT: prevents any accidental preloaded/fake data
        guard !savedTitles.isEmpty else {
            savedBooks = []
            return
        }
        
        savedBooks = allBooks.filter { savedTitles.contains($0.title) }
    }
    
    // MARK: - REMOVE
    private func removeFromTBR(_ book: Book) {
        var savedTitles = UserDefaults.standard.stringArray(forKey: "ToBeReadList") ?? []
        savedTitles.removeAll { $0 == book.title }
        UserDefaults.standard.set(savedTitles, forKey: "ToBeReadList")
        loadBooks()
    }
    
    // MARK: - MOVE TO READ
    private func moveToRead(_ book: Book) {
        
        // Remove from TBR
        removeFromTBR(book)
        
        // Add to read list
        var readTitles = UserDefaults.standard.stringArray(forKey: "BooksReadList") ?? []
        
        if !readTitles.contains(book.title) {
            readTitles.append(book.title)
            UserDefaults.standard.set(readTitles, forKey: "BooksReadList")
        }
    }
}

#Preview {
    NavigationStack {
        BooksToBeReadView()
    }
}
