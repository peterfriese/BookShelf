//
//  SearchBooksView.swift
//  BookShelf
//
//  Created by Peter Friese on 06.05.21.
//

import SwiftUI

struct SearchBooksView: View {
  @StateObject var viewModel = OpenLibrarySearchService()
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
          }
        }
        .listStyle(PlainListStyle())
        .resignKeyboardOnDragGesture()
      }
      .navigationTitle("Search")
      //      .navigationBarHidden(isSearchFieldActive)
    }
  }
}

struct SearchBooksView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationView {
        SearchBooksView()
          .navigationTitle("Search")
          .preferredColorScheme(.dark)
      }
      NavigationView {
        SearchBooksView()
          .navigationTitle("Search")
          .preferredColorScheme(.light)
      }
      
    }
  }
}
