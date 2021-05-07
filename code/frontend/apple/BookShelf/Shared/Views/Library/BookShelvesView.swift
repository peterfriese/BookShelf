//
//  BookShelvesView.swift
//  BookShelf
//
//  Created by Peter Friese on 04.05.21.
//

import SwiftUI

struct BookShelvesView: View {
  @EnvironmentObject var bookShelfStore: BookShelfStore
  @EnvironmentObject var bookStore: BookStore
  @EnvironmentObject var authenticationService: AuthenticationService
  
  @State var showsAddNewShelf = false
  @State var showsSettingsView = false
  
  var body: some View {
    List {
      ForEach(Array(bookShelfStore.shelves.enumerated()), id: \.element.id) { index, item in
        NavigationLink(destination: BookShelfView(bookShelf: $bookShelfStore.shelves[index]).environmentObject(bookStore)) {
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
    .bottomToolbar(title: "New Folder", systemImage: "folder.badge.plus") {
      self.showsAddNewShelf.toggle()
    }
    .toolbar {
      ToolbarItem {
        Button(action: { showsSettingsView.toggle() } ) {
          Image(systemName: "person.circle")
        }
      }
    }
    .onAppear() {
      bookShelfStore.subscribe()
    }
    .sheet(isPresented: $showsSettingsView) {
      SettingsView()
    }
    .alert(isPresented: $showsAddNewShelf, TextAlert(title: "Title", action: { text in
      if let shelfTitle = text {
        self.bookShelfStore.createNewShelf(title: shelfTitle)
      }
    }))
  }
}

struct BookShelvesView_Previews: PreviewProvider {
  static let bookShelfStore = BookShelfStore(shelves: BookShelf.samples)
  static var previews: some View {
    NavigationView {
      BookShelvesView()
        .environmentObject(bookShelfStore)
    }
  }
}
