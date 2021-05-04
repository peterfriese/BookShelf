//
//  BookShelvesView.swift
//  BookShelf
//
//  Created by Peter Friese on 04.05.21.
//

import SwiftUI

struct BookShelvesView: View {
  @ObservedObject var store: BookShelfStore
  
  var body: some View {
    VStack(alignment: .leading) {
      List {
        ForEach(Array(store.shelves.enumerated()), id: \.element.id) { index, item in
          NavigationLink(destination: BookShelfView(bookShelf: $store.shelves[index])) {
            HStack {
              Label(item.title, systemImage: "folder")
              Spacer()
              Text("\(item.count)")
            }
          }
        }
      }
      .listStyle(SidebarListStyle())
      .navigationTitle("My Library")
      .toolbar {
        #if os(iOS)
        ToolbarItem(placement: .bottomBar) {
          Button(action: { }) {
            Image(systemName: "folder.badge.plus")
          }
        }
        #endif
      }
      #if os(macOS)
      HStack {
        Button(action: {})  {
          Label("New Folder", systemImage: "plus.circle")
        }
        .buttonStyle(PlainButtonStyle())
        .padding([.leading, .bottom], 8)
      }
      #endif
    }
  }
}

struct BookShelvesView_Previews: PreviewProvider {
  static let store = BookShelfStore(shelves: BookShelf.samples)
  static var previews: some View {
    NavigationView {
      BookShelvesView(store: store)
    }
  }
}
