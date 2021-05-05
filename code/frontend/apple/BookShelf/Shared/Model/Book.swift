//
//  Book.swift
//  BookShelf
//
//  Created by Peter Friese on 04.05.21.
//

import Foundation
import FirebaseFirestoreSwift

struct Book: Codable, Hashable, Identifiable {
  @DocumentID var id = UUID().uuidString
  var title: String
  var author: String
  var isbn: String
  var pages: Int
  var isRead: Bool = false
}

extension Book {
  var smallCoverImageName: String { return "\(isbn)-S" }
  var mediumCoverImageName: String { return "\(isbn)-M" }
  var largeCoverImageName: String { return "\(isbn)-L" }
}

extension Book {
  static let reading = [
    Book(title: "Why we sleep", author: "Matthew Walker", isbn: "9780141983769", pages: 368),
    Book(title: "The Hitchhiker's Guide to the Galaxy", author: "Douglas Adams", isbn: "9780671461492", pages: 216),
  ]
  
  static let wantToRead = [
    Book(title: "Changer", author: "Matt Gemmell", isbn: "9781916265202", pages: 476),
  ]
  
  static let read = [
    Book(title: "SwiftUI for Absolute Beginners", author: "Jayant Varma", isbn: "9781484255155", pages: 200),
  ]
  
  static let samples = [reading, wantToRead, read].flatMap { $0 }

}
