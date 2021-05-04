//
//  BookRowView.swift
//  BookShelf
//
//  Created by Peter Friese on 04.05.21.
//

import SwiftUI

struct BookRowView: View {
  @Binding var book: Book
  
  var body: some View {
    NavigationLink(destination: BookDetailsScreen(book: $book)) {
      HStack(alignment: .top) {
        Image(book.mediumCoverImageName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 90)
        VStack(alignment: .leading) {
          Text(book.title)
            .font(.headline)
          Text("by \(book.author)")
            .font(.subheadline)
          Text("\(book.pages) pages")
            .font(.subheadline)
        }
        Spacer()
      }
    }
  }
}

struct BookRowView_Previews: PreviewProvider {
  static var previews: some View {
    BookRowView(book: .constant(Book.samples[0]))
      .previewLayout(.sizeThatFits)
  }
}
