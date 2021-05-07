//
//  BookDetailsScreen.swift
//  BookShelf
//
//  Created by Peter Friese on 04.05.21.
//

import SwiftUI
import Kingfisher

struct BookDetailsView: View {
  @Binding var book: Book
  @State var showEditBookView = false
  
  func detailsRow(_ label: String, systemImage: String, data: Int) -> some View {
    detailsRow(label, systemImage: systemImage, data: String(data))
  }
  
  func detailsRow(_ label: String, systemImage: String, data: String) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Label(label, systemImage: systemImage)
        .font(.headline)
      Text(data)
    }
  }
  
  var body: some View {
    Form {
      HStack(alignment: .top, spacing: 16) {
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
      }
//      Section {
//        detailsRow("Author", systemImage: "person.crop.rectangle", data: book.author)
//        detailsRow("Genre", systemImage: "tag", data: "Science Fiction")
//      }
      Section(header: Text("Details")) {
        detailsRow("ISBN", systemImage: "number", data: book.isbn)
        detailsRow("Pages", systemImage: "book", data: book.pages)
      }
      Section {
        HStack {
          Text("Reading status")
            .font(.headline)
          Spacer()
          Button(action: { book.isRead.toggle() }) {
            Image(systemName: book.isRead ? "checkmark.circle.fill" : "circlebadge")
              .resizable()
              .frame(width: 22, height: 22, alignment: .center)
          }
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button(action: { showEditBookView.toggle() }) {
          Text("Edit")
        }
      }
    }
    .sheet(isPresented: $showEditBookView) {
      BookEditView(book: $book)
    }
    .navigationTitle(book.title)
  }
}

struct BookDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      BookDetailsView(book: .constant(Book.samples[0]))
    }
    .preferredColorScheme(.dark)
  }
}
