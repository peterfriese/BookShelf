//
//  BookShelfView.swift
//  BookShelf
//
//  Created by Peter Friese on 04.05.21.
//

import SwiftUI

struct BookShelfView: View {
  @Binding var bookShelf: BookShelf
  @EnvironmentObject var bookStore: BookStore
  @State var isSearchViewPresented = false
  
  var body: some View {
    List {
      //      // Inspired by https://stackoverflow.com/a/57837054/281221
      //      // But this breaks when deleting an item
      //      ForEach(booksViewModel.books.indices) { index in
      //        BookRowView(book: $booksViewModel.books[index])
      //      }
      //      .onDelete { indexSet in
      //        booksViewModel.books.remove(atOffsets: indexSet)
      //      }
      
      //      // Inspired by https://stackoverflow.com/a/63145650/281221
      //      // This doesn't refresh the details view immediately after editing the book in the edit view
      //      ForEach(Array(zip(booksViewModel.books.indices, booksViewModel.books)), id: \.1) { index, item in
      //        BookRowView(book: $booksViewModel.books[index])
      //      }
      //      .onDelete { indexSet in
      //        booksViewModel.books.remove(atOffsets: indexSet)
      //      }
      
      // Inspired by https://stackoverflow.com/a/59295207/281221
      // This doesn't refresh the details view immediately after editing the book in the edit view
      // UPDATE: fixed by using `id: \.element.id` to identify the element (after all, we're editing the element!!!!! so it does change entirely and thus the edited version is != the old version!
      ForEach(Array(bookStore.books.enumerated()), id: \.element.id) { index, item in
        BookRowView(book: $bookStore.books[index])
      }
      .onDelete { indexSet in
        bookStore.removeBooks(atOffsets: indexSet)
      }
      
      //      // This is inpired by https://lostmoa.com/blog/BindingToArrayInSwiftUI/
      //      // But when deleting items, the list will animate in unexpected ways, as the elements are identified by their
      //      // index, not their real identity. So when deleitng an element at index 2, the following element will become
      //      // the element at index 2, and this will result in funny animations.
      //      // UPDATE: solved by adding `.id(booksViewModel.books[index].id)`
      //      ForEach(0..<booksViewModel.books.count, id: \.self) { index in
      //        BookRowView(book: $booksViewModel.books[index])
      //          .id(booksViewModel.books[index].id)
      //      }
      //      .onDelete { indexSet in
      //        booksViewModel.books.remove(atOffsets: indexSet)
      //      }
      //      .listRowBackground(Color(UIColor.systemGray6))
    }
    .navigationTitle(bookShelf.title)
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button(action: { isSearchViewPresented.toggle() }) {
          Image(systemName: "plus")
        }
      }
    }
    .sheet(isPresented: $isSearchViewPresented) {
      SearchBooksView(bookShelf: bookShelf)
    }
    .onAppear() {
      if let shelfId = bookShelf.id {
        bookStore.subscribe(shelfId: shelfId)
      }
    }
  }
}

struct BookShelfView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationView {
        BookShelfView(bookShelf: .constant(BookShelf.samples[0]))
          .navigationTitle("Books")
          .preferredColorScheme(.dark)
      }
      NavigationView {
        BookShelfView(bookShelf: .constant(BookShelf.samples[0]))
          .navigationTitle("Books")
          .preferredColorScheme(.light)
      }
      
    }
  }
}
