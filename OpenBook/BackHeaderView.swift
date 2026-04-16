//
//  BackHeaderView.swift
//  OpenBook
//
//  Created by Tommy McClure on 3/25/26.
//

import SwiftUI

struct BackHeaderView: View {
    
    var title: String
    var onBack: () -> Void
    
    var body: some View {
        HStack {
            // Back Button
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Title (Matches HeaderView)
            Text(title)
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
            
            Spacer()
            
            // Invisible icon to keep title centered
            Image(systemName: "chevron.left")
                .font(.title2)
                .opacity(0)
        }
        .padding()
        .background(Color(red: 62/255, green: 39/255, blue: 35/255))
    }
}

#Preview {
    BackHeaderView(title: "Book Title") {
        print("Back tapped")
    }
    .previewLayout(.sizeThatFits)
}
