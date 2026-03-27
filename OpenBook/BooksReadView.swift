//
//  BooksReadView.swift
//  OpenBook
//
//  Created by Tommy McClure on 3/3/26.
//

import SwiftUI

struct BooksReadView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack {
            
            // Background
            Color(red: 250/255, green: 243/255, blue: 224/255)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Your read books will appear here.")
                    .font(.title3)
                
                Spacer()
            }
        }
        
        // MARK: Header with back arrow
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
                
                // Invisible spacer to keep title centered
                Image(systemName: "arrow.left")
                    .opacity(0)
            }
            .padding()
            .background(Color(red: 62/255, green: 39/255, blue: 35/255))
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        BooksReadView()
    }
}
