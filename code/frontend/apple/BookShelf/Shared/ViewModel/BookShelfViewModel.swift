//
//  BookShelfViewModel.swift
//  BookShelf
//
//  Created by Peter Friese on 04.05.21.
//

import Foundation

class BookShelfStore: ObservableObject {
  @Published var shelves: [BookShelf]
  
  init(shelves: [BookShelf]) {
    self.shelves = shelves
  }
}
