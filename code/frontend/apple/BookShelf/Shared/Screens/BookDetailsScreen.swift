//
//  BookDetailsScreen.swift
//  BookShelf
//
//  Created by Peter Friese on 04.05.21.
//

import SwiftUI

struct BookDetailsScreen: View {
  @Binding var book: Book
  @State var showEditBookView = false
  
  var body: some View {
    Form {
      Text(book.title)
      Image(book.largeCoverImageName)
        .resizable()
        .scaledToFit()
        .shadow(radius: 10)
        .padding()
      Label(book.author, systemImage: "person.crop.rectangle")
      Label("\(book.isbn) pages", systemImage: "number")
      Label("\(book.pages) pages", systemImage: "book")
      Toggle("Read", isOn: .constant(book.isRead))
      Button(action: { showEditBookView.toggle() }) {
        Label("Edit", systemImage: "pencil")
      }
    }
    .sheet(isPresented: $showEditBookView) {
      BookEditScreen(book: $book)
    }
    .navigationTitle(book.title)
  }
}

struct BookDetailsScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      BookDetailsScreen(book: .constant(Book.samples[0]))
    }
    .preferredColorScheme(.dark)
  }
}
