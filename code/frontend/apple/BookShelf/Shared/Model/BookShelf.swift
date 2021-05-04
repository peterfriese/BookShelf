//
//  BookShelf.swift
//  BookShelf
//
//  Created by Peter Friese on 04.05.21.
//

import Foundation

struct BookShelf: Hashable, Identifiable {
  var id = UUID().uuidString
  var title: String
  var count: Int {
    return books.count
  }
  var books: [Book]
}

extension BookShelf {
  static let samples = [
    BookShelf(title: "Currently reading", books: Book.reading),
    BookShelf(title: "Read", books: Book.read),
    BookShelf(title: "Want to read", books: Book.wantToRead)
  ]
}
