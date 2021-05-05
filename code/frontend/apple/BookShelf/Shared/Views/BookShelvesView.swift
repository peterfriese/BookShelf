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
    .bottomToolbar()
    .onAppear() {
      store.subscribe()
    }
  }
}

extension View {
  func bottomToolbar() -> some View {
    self.modifier(BottomToolbar())
  }
}

struct BottomToolbar: ViewModifier {
  func body(content: Content) -> some View {
    #if os(macOS)
    content
      .overlay(
        HStack {
          Button(action: {})  {
            Label("New Folder", systemImage: "plus.circle")
          }
          .buttonStyle(PlainButtonStyle())
          .padding([.leading, .bottom], 8)
          Spacer()
        }
        , alignment: .bottom)
    #elseif os(iOS)
    content
      .toolbar {
        ToolbarItem(placement: .bottomBar) {
          Button(action: { }) {
            Image(systemName: "folder.badge.plus")
          }
        }
      }
    #endif
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
