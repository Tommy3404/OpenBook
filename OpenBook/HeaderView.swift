//
//  HeaderView.swift
//  OpenBook
//
//  Created by Tommy McClure on 3/25/26.
//

import SwiftUI

import SwiftUI

struct HeaderView: View {
    
    var title: String
    @Binding var showMenu: Bool
    @Binding var isLoggedIn: Bool
    
    var body: some View {
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
}

#Preview {
    // Create some mock state for bindings
    @State var showMenu = false
    @State var isLoggedIn = true
    
    HeaderView(title: "Header", showMenu: $showMenu, isLoggedIn: $isLoggedIn)
        .previewLayout(.sizeThatFits)
}
