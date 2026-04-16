//
//  BookDetailView.swift
//  OpenBook
//

import SwiftUI
import UIKit

// MARK: - Keyboard Helper
extension UIApplication {
    func hideKeyboard() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

struct BookDetailView: View {
    
    let book: Book
    
    @State private var reviewText: String = ""
    
    // MARK: - ⭐ Rating
    @State private var userRating: Int = 0
    
    // MARK: - ALERT SYSTEM (FIXED)
    enum ActiveAlert: Identifiable {
        case saved
        case added
        case alreadyExists
        
        var id: Int {
            hashValue
        }
    }
    
    @State private var activeAlert: ActiveAlert?
    
    // MARK: - Theme
    private let backgroundColor = Color(red: 250/255, green: 243/255, blue: 224/255)
    private let primaryColor = Color(red: 166/255, green: 124/255, blue: 82/255)
    
    var body: some View {
        
        ZStack {
            
            // MARK: BACKGROUND
            backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    // MARK: BOOK COVER
                    Image(book.coverImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    
                    // MARK: TITLE
                    Text(book.title)
                        .font(.title)
                        .bold()
                        .foregroundColor(primaryColor)
                    
                    // MARK: ⭐ STAR RATING
                    HStack(spacing: 6) {
                        ForEach(1...5, id: \.self) { index in
                            
                            Image(systemName: index <= userRating ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    userRating = index
                                }
                        }
                        
                        Text(userRating == 0
                             ? String(format: "%.1f", book.rating)
                             : "\(userRating).0")
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
                    
                    // MARK: 📚 ADD TO TBR
                    Button {
                        
                        var list = UserDefaults.standard.stringArray(forKey: "ToBeReadList") ?? []
                        
                        if list.contains(book.title) {
                            activeAlert = .alreadyExists
                        } else {
                            list.append(book.title)
                            UserDefaults.standard.set(list, forKey: "ToBeReadList")
                            activeAlert = .added
                        }
                        
                    } label: {
                        Text("Add to Books To Be Read")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // MARK: REVIEW
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("Your Review")
                            .font(.headline)
                            .foregroundColor(primaryColor)
                        
                        TextEditor(text: $reviewText)
                            .frame(height: 150)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                    }
                    .padding(.horizontal)
                    
                    // MARK: SAVE REVIEW
                    Button {
                        activeAlert = .saved
                        UIApplication.shared.hideKeyboard()
                    } label: {
                        Text("Save Review")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
        }
        
        // MARK: DISMISS KEYBOARD
        .contentShape(Rectangle())
        .simultaneousGesture(
            TapGesture().onEnded {
                UIApplication.shared.hideKeyboard()
            }
        )
        
        // MARK: ALERTS (FIXED)
        .alert(item: $activeAlert) { alert in
            switch alert {
                
            case .saved:
                return Alert(
                    title: Text("Saved!"),
                    message: Text("Your review was saved."),
                    dismissButton: .default(Text("OK"))
                )
                
            case .added:
                return Alert(
                    title: Text("Success"),
                    message: Text("Book added to your To Be Read list."),
                    dismissButton: .default(Text("OK"))
                )
                
            case .alreadyExists:
                return Alert(
                    title: Text("Already Added"),
                    message: Text("This book is already in your To Be Read list."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        BookDetailView(
            book: Book(title: "Sample Book", rating: 4.5, coverImage: "mockingbird")
        )
    }
}
