//
//  Book.swift
//  OpenBook
//
//  Created by Tommy McClure on 4/13/26.
//

import Foundation

struct Book: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let rating: Double
    let coverImage: String
}
