//
//  AuthenticationService.swift
//  BookShelf (iOS)
//
//  Created by Peter Friese on 07.05.21.
//

import Foundation
import Firebase
import os

class AuthenticationService: ObservableObject {
  @Published var user: User?
  
  private var handle: AuthStateDidChangeListenerHandle?
  
  let logger = Logger(subsystem: "dev.peterfriese.BookShelf", category: "authentication")
  
  func signIn() {
    registerStateListener()
    if Auth.auth().currentUser == nil {
      Auth.auth().signInAnonymously()
    }
  }
  
  func signOut() {
    do {
      try Auth.auth().signOut()
    }
    catch {
      print("error when trying to sign out: \(error.localizedDescription)")
    }
  }
  
  private func registerStateListener() {
    if handle == nil {
      handle = Auth.auth().addStateDidChangeListener { auth, user in
        self.user = user
        
        if let user = user {
          if user.isAnonymous {
            self.logger.debug("User signed in anonymously with user ID \(user.uid).")
          }
          else {
            self.logger.debug("User signed in with user ID \(user.uid). Email: \(user.email ?? "(empty)"), display name: [\(user.displayName ?? "(empty)")]")
          }
        }
        else {
          self.logger.debug("User signed out.")
          self.signIn() // this is so the user is always signed in anonymously
        }
      }
    }
  }

}
