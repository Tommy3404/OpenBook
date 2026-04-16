//
//  SearchView.swift
//  OpenBook
//

import SwiftUI

struct SearchView: View {
    
    @Binding var name: String
    @Binding var isLoggedIn: Bool
    
    // ✅ REQUIRED ADDITION
    var updateName: (String) -> Void
    
    @State private var showMenu = false
    @State private var searchText: String = ""
    
    private let backgroundColor = Color(red: 250/255, green: 243/255, blue: 224/255)
    private let accentColor = Color(red: 235/255, green: 213/255, blue: 195/255)
    private let primaryColor = Color(red: 166/255, green: 124/255, blue: 82/255)
    
    private let books: [Book] = [
        Book(title: "To Kill a Mockingbird", rating: 4.8, coverImage: "mockingbird"),
        Book(title: "Ready Player One", rating: 4.6, coverImage: "ReadyPlayerOne"),
        Book(title: "The Great Gatsby", rating: 4.4, coverImage: "GreatGatsby"),
        Book(title: "IT", rating: 4.5, coverImage: "IT")
    ]
    
    private var filteredBooks: [Book] {
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.isEmpty {
            return []
        }
        
        return books.filter {
            $0.title.localizedCaseInsensitiveContains(trimmedText)
        }
    }
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Spacer().frame(height: 70)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search for a book...", text: $searchText)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                    
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 2)
                .padding(.horizontal)
                
                if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 40))
                            .foregroundColor(primaryColor.opacity(0.6))
                        
                        Text("Start typing to search for books")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                } else if filteredBooks.isEmpty {
                    
                    Spacer()
                    Text("No results found.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Spacer()
                    
                } else {
                    
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(filteredBooks) { book in
                                NavigationLink(destination: BookDetailView(book: book)) {
                                    BookRowView(
                                        book: book,
                                        primaryColor: primaryColor,
                                        accentColor: accentColor
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 10)
        }
        
        // MARK: HEADER (FIXED)
        .overlay(alignment: .top) {
            HeaderView(
                title: "Search",
                currentPage: "Search",
                showMenu: $showMenu,
                isLoggedIn: $isLoggedIn,
                updateName: updateName   // ✅ FIX ADDED
            )
            .zIndex(999)
        }
        
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Book Row View (UNCHANGED)

struct BookRowView: View {
    let book: Book
    let primaryColor: Color
    let accentColor: Color
    
    var body: some View {
        HStack(spacing: 15) {
            
            Image(book.coverImage)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 90)
                .clipped()
                .cornerRadius(8)
                .shadow(radius: 2)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(book.title)
                    .font(.headline)
                    .foregroundColor(primaryColor)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    
                    Text(String(format: "%.1f / 5", book.rating))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(accentColor, lineWidth: 1)
        )
    }
}

// MARK: - PREVIEW (FIXED)

#Preview {
    NavigationStack {
        SearchView(
            name: .constant("Tommy"),
            isLoggedIn: .constant(true),
            updateName: { _ in }   // ✅ REQUIRED
        )
    }
}
