//
//  BooksViewModel.swift
//  BookShelf
//
//  Created by Peter Friese on 04.05.21.
//

import Foundation

class BooksViewModel: ObservableObject {
  @Published var books: [Book] = Book.samples
}
