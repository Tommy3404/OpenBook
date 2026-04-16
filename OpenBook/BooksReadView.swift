//
//  BooksReadView.swift
//  OpenBook
//

import SwiftUI

struct BooksReadView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var savedBooks: [Book] = []
    @State private var selectedBook: Book? = nil
    @State private var showActionSheet = false
    
    // MARK: - Theme
    private let backgroundColor = Color(red: 250/255, green: 243/255, blue: 224/255)
    private let headerColor = Color(red: 62/255, green: 39/255, blue: 35/255)
    
    private let allBooks: [Book] = [
        Book(title: "To Kill a Mockingbird", rating: 4.8, coverImage: "mockingbird"),
        Book(title: "Ready Player One", rating: 4.6, coverImage: "ReadyPlayerOne"),
        Book(title: "The Great Gatsby", rating: 4.4, coverImage: "GreatGatsby"),
        Book(title: "IT", rating: 4.5, coverImage: "IT")
    ]
    
    var body: some View {
        
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack {
                
                if savedBooks.isEmpty {
                    Spacer()
                    
                    Text("No books read yet.")
                        .font(.title3)
                        .foregroundColor(.gray)
                    
                    Spacer()
                } else {
                    
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
                                
                                // TAP ACTION
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
        
        // MARK: HEADER (matches your app style)
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
                
                Text("Books Read")
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
        .onAppear {
            loadBooks()
        }
        
        // MARK: ACTION SHEET
        .confirmationDialog(
            "Remove this book?",
            isPresented: $showActionSheet,
            titleVisibility: .visible
        ) {
            
            Button("Remove from Read List", role: .destructive) {
                if let book = selectedBook {
                    removeFromRead(book)
                }
            }
            
            Button("Cancel", role: .cancel) {}
        }
    }
    
    // MARK: Load
    private func loadBooks() {
        let savedTitles = UserDefaults.standard.stringArray(forKey: "BooksReadList") ?? []
        savedBooks = allBooks.filter { savedTitles.contains($0.title) }
    }
    
    // MARK: Remove
    private func removeFromRead(_ book: Book) {
        var savedTitles = UserDefaults.standard.stringArray(forKey: "BooksReadList") ?? []
        savedTitles.removeAll { $0 == book.title }
        UserDefaults.standard.set(savedTitles, forKey: "BooksReadList")
        loadBooks()
    }
}

#Preview {
    NavigationStack {
        BooksReadView()
    }
}
