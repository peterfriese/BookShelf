//
//  BookShelfApp.swift
//  Shared
//
//  Created by Peter Friese on 04.05.21.
//

import SwiftUI
import Firebase

@main
struct BookShelfApp: App {
  // By pulling up the source of truth to the app, we make sure that all the app's
  // windows share the same source of truth. In case each BooksListView had their own
  // @StateObject var booksViewModel = BooksViewModel(), any changes made to any of
  // them wouldn't be reflected on the other ones.
  // See this in action by running the app on an iPad and then use multi-tasking to arrange
  // two app windows side-by-side.
  @StateObject var bookShelfStore = BookShelfStore(shelves: BookShelf.samples)
  @StateObject var bookStore = BookStore(books: Book.samples)
  @StateObject var authenticationService = AuthenticationService()
  
  init() {
    FirebaseApp.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      NavigationView {
        BookShelvesView()
          .environmentObject(bookShelfStore)
          .environmentObject(bookStore)
          .environmentObject(authenticationService)
        Text("Select a shelf to see its books")
        Text("Select a book to see its details")
      }
      .onAppear() {
        authenticationService.$user
          .assign(to: &bookShelfStore.$user)
        
        authenticationService.$user
          .assign(to: &bookStore.$user)
        
        authenticationService.signIn()
      }
    }
  }
}

#if os(iOS)
// from https://developer.apple.com/forums/thread/651511?answerId=668188022#668188022
extension UISplitViewController {
  open override func viewDidLoad() {
    preferredDisplayMode = .twoBesideSecondary
  }
}
#endif
