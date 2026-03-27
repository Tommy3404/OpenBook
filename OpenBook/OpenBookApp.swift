//
//  OpenBookApp.swift
//  OpenBook
//
//  Created by Tommy McClure on 2/18/26.
//

import SwiftUI

@main
struct OpenBookApp: App {
    
    @State private var isLoggedIn = false
    @State private var currentName = ""
    
    var body: some Scene {
        WindowGroup {
            
            NavigationStack {   
                
                Group {
                    if isLoggedIn {
                        HomeView(name: $currentName,
                                 isLoggedIn: $isLoggedIn)
                    } else {
                        LoginView(isLoggedIn: $isLoggedIn,
                                  currentName: $currentName)
                    }
                }
            }
            .preferredColorScheme(.light)
        }
    }
}
