//
//  BookShelfViewModel.swift
//  BookShelf
//
//  Created by Peter Friese on 04.05.21.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift
import os


class BookShelfStore: ObservableObject {
  // MARK: - Dependencies
  var db = Firestore.firestore()
  
  // MARK: - Publishers
  @Published var shelves = [BookShelf]()
  
  // MARK: - Private attributes
  private var userId: String = "123"
  private var listenerRegistration: ListenerRegistration?
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Logging
  let logger = Logger(subsystem: "dev.peterfriese.BookShelf.dev", category: "persistence")
  
  init(shelves: [BookShelf]) {
    self.shelves = shelves
  }
  
  deinit {
    unsubscribe()
  }
  
  public func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }
  
  func subscribe() {
    if listenerRegistration == nil {
      let query = db.collection("shelves")
        .whereField("userId", isEqualTo: self.userId)

      listenerRegistration = query
        .addSnapshotListener { [weak self] (querySnapshot, error) in
          guard let documents = querySnapshot?.documents else {
            self?.logger.debug("No documents in 'shelves' collection")
            return
          }
          
          self?.shelves = documents.compactMap { queryDocumentSnapshot in
            let result = Result { try queryDocumentSnapshot.data(as: BookShelf.self) }
            
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
  }
}
