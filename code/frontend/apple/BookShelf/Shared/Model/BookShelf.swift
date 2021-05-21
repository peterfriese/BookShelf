//
//  BookShelf.swift
//  BookShelf
//
//  Created by Peter Friese on 04.05.21.
//

import Foundation
import FirebaseFirestoreSwift

struct BookShelf: Codable, Hashable, Identifiable {
  @DocumentID var id = UUID().uuidString
  var userId: String?
  var title: String
  var books = [Book]()
  
  enum CodingKeys: String, CodingKey {
    case id
    case userId
    case title
  }
}

extension BookShelf {
  var count: Int {
    return books.count
  }
}

extension BookShelf {
  static let samples = [
    BookShelf(title: "Currently reading", books: Book.reading),
    BookShelf(title: "Read", books: Book.read),
    BookShelf(title: "Want to read", books: Book.wantToRead)
  ]
}
