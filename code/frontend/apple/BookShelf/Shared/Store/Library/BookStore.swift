//
//  BookStore.swift
//  BookShelf
//
//  Created by Peter Friese on 05.05.21.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift
import os

class BookStore: ObservableObject {
  // MARK: - Dependencies
  var db = Firestore.firestore()
  
  // MARK: - Publishers
  @Published var user: User?
  @Published var books = [Book]()
  
  // MARK: - Private attributes
  @Published private var userId: String = "unknown"
  private var listenerRegistration: ListenerRegistration?
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Logging
  let logger = Logger(subsystem: "dev.peterfriese.BookShelf", category: "persistence | \(#fileID)")
  
  init(books: [Book]) {
    self.books = books
    observeUser()
  }
  
  func observeUser() {
    $user
      .compactMap { user in
        user?.uid
      }
      .assign(to: &$userId)
    
    $userId
      .receive(on: DispatchQueue.main)
      .sink { userId in
        self.logger.debug("User \(userId) has logged in.")
        self.refresh()
      }
      .store(in: &cancellables)
  }
  
  deinit {
    unsubscribe()
  }
  
  func refresh() {
    self.unsubscribe()
    self.subscribe(shelfId: "")
  }
  
  func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }
  
  func subscribe(shelfId: String) {
    if listenerRegistration != nil {
      unsubscribe()
    }
    let query = db.collection("books")
      .whereField("userId", isEqualTo: self.userId)
      .whereField("shelfId", isEqualTo: shelfId)
    
    listenerRegistration = query
      .addSnapshotListener { [weak self] (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          self?.logger.debug("No documents in 'shelves' collection")
          return
        }
        
        self?.books = documents.compactMap { queryDocumentSnapshot in
          let result = Result { try queryDocumentSnapshot.data(as: Book.self) }
          
          switch result {
          case .success(let book):
            if let book = book {
              // A Book value was successfully initialized from the DocumentSnapshot.
              return book
            }
            else {
              // A nil value was successfully initialized from the DocumentSnapshot,
              // or the DocumentSnapshot was nil.
              self?.logger.debug("Document doesn't exist.")
              return nil
            }
          case .failure(let error):
            // A Book value could not be initialized from the DocumentSnapshot.
            switch error {
            case DecodingError.typeMismatch(_, let context):
              self?.logger.debug("\(error.localizedDescription): \(context.debugDescription)")
            case DecodingError.valueNotFound(_, let context):
              self?.logger.debug("\(error.localizedDescription): \(context.debugDescription)")
            case DecodingError.keyNotFound(_, let context):
              self?.logger.debug("\(error.localizedDescription): \(context.debugDescription)")
            case DecodingError.dataCorrupted(let key):
              self?.logger.debug("\(error.localizedDescription): \(key.debugDescription)")
            default:
              self?.logger.debug("Error decoding document: \(error.localizedDescription)")
            }
            return nil
          }
        }
      }
  }
  
  func addBook(_ book: Book, to shelf: BookShelf? = nil) {
    do {
      var modifiableBook = book
      if shelf != nil {
        modifiableBook.shelfId = shelf?.id
        modifiableBook.userId = userId
      }
      let newDocReference = try db.collection("books").addDocument(from: modifiableBook)
      self.logger.debug("Book stored with new document reference: \(newDocReference)")
    }
    catch {
      self.logger.debug("Error saving doucment: \(error.localizedDescription)")
    }
  }
  
  func removeBooks(atOffsets indexSet: IndexSet) {
    let books = indexSet.lazy.map { self.books[$0] }
    books.forEach { book in
      if let documentId = book.id {
        db.collection("books").document(documentId).delete { error in
          if let error = error {
            self.logger.debug("Unable to remove document: \(error.localizedDescription)")
          }
        }
      }
    }
  }

}
