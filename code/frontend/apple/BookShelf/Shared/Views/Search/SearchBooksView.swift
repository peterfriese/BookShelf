//
//  SearchBooksView.swift
//  BookShelf
//
//  Created by Peter Friese on 06.05.21.
//

import SwiftUI
import Firebase

struct SearchBooksView: View {
  @Environment(\.presentationMode) var presentationMode
  @StateObject var viewModel = OpenLibrarySearchService()
  @EnvironmentObject var bookStore: BookStore
  
  var bookShelf: BookShelf
  
  @State var searchText = ""
  @State var isSearchFieldActive = false
  
  var body: some View {
    NavigationView {
      VStack {
        SearchBar(text: $viewModel.searchTerm, isEditing: $isSearchFieldActive)
        if viewModel.isLoading {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
        }
        List {
          ForEach(viewModel.searchResult) { book in
            SearchBookRowView(book: book)
              .contextMenu {
                Button(action: { addBook(book) }) {
                  Label("Add", systemImage: "plus")
                }
              }
          }
        }
        .listStyle(PlainListStyle())
        .resignKeyboardOnDragGesture()
      }
      .navigationTitle("Search")
      //      .navigationBarHidden(isSearchFieldActive)
      .analyticsScreen(name: "search")
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("Done") {
            dimsiss()
          }
        }
      }
    }
  }
  
  func dimsiss() {
    presentationMode.wrappedValue.dismiss()
  }
  
  func addBook(_ book: Book) {
    bookStore.addBook(book, to: bookShelf)
    dimsiss()
  }
  
}

struct SearchBooksView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationView {
        SearchBooksView(bookShelf: BookShelf.samples[0])
          .navigationTitle("Search")
          .preferredColorScheme(.dark)
      }
      NavigationView {
        SearchBooksView(bookShelf: BookShelf.samples[0])
          .navigationTitle("Search")
          .preferredColorScheme(.light)
      }
      
    }
  }
}
