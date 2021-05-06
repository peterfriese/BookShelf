//
//  BookRowView.swift
//  BookShelf
//
//  Created by Peter Friese on 04.05.21.
//

import SwiftUI
import SystemColors

struct BookRowView: View {
  @Binding var book: Book
  
  var body: some View {
    NavigationLink(destination: BookDetailsView(book: $book)) {
      HStack(alignment: .top) {
        Image(book.mediumCoverImageName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 90)
          .cornerRadius(4.0)
          .shadow(color: .systemGray, radius: 4, x: 2.0, y: 2.0)
          .padding(.bottom)
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
    Group {
      BookRowView(book: .constant(Book.samples[0]))
        .previewLayout(.sizeThatFits)
      BookRowView(book: .constant(Book.samples[0]))
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
  }
}
