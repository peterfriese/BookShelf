//
//  SearchBookRowView.swift
//  BookShelf
//
//  Created by Peter Friese on 06.05.21.
//

import SwiftUI
import SystemColors
import Kingfisher

struct SearchBookRowView: View {
  var book: Book
  
  var body: some View {
    HStack(alignment: .top) {
      if book.hasImageUrl {
        KFImage(book.mediumCoverImageUrl)
          .cancelOnDisappear(true)
          .placeholder {
            Image(systemName: "book.closed")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .padding()
              .frame(height: 90)
              .cornerRadius(4.0)
              .shadow(color: .systemGray, radius: 4, x: 2.0, y: 2.0)
              .padding(.bottom)
          }
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 90)
          .cornerRadius(4.0)
          .shadow(color: .systemGray, radius: 4, x: 2.0, y: 2.0)
          .padding(.bottom)
      }
      else {
        Image(book.mediumCoverImageName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 90)
          .cornerRadius(4.0)
          .shadow(color: .systemGray, radius: 4, x: 2.0, y: 2.0)
          .padding(.bottom)
      }
      VStack(alignment: .leading) {
        Text(book.title)
          .font(.headline)
        Text("by \(book.author)")
          .font(.subheadline)
      }
      Spacer()
    }
  }
}

struct SearchBookRowView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SearchBookRowView(book: Book.read[0])
        .previewLayout(.sizeThatFits)
      SearchBookRowView(book: Book.samples[0])
        .previewLayout(.sizeThatFits)
      SearchBookRowView(book: Book.samples[0])
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
  }
}
