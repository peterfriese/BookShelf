//
//  BottomToolbar.swift
//  BookShelf (iOS)
//
//  Created by Peter Friese on 07.05.21.
//

import SwiftUI

extension View {
  func bottomToolbar(title: String, systemImage: String, onButtonTapped: @escaping () -> Void) -> some View {
    self.modifier(BottomToolbar(title: title, systemImage: systemImage, onButtonTapped: onButtonTapped))
  }
}

struct BottomToolbar: ViewModifier {
  var title: String
  var systemImage: String
  var onButtonTapped: () -> Void
  func body(content: Content) -> some View {
    #if os(macOS)
    content
      .overlay(
        HStack {
          Button(action: { onButtonTapped() })  {
            Label(title, systemImage: systemImage)
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
          Button(action: { onButtonTapped() }) {
            Image(systemName: systemImage)
          }
        }
      }
    #endif
  }
}

struct BottomToolbarContentView: View {
  var body: some View {
    Text("Hello, World!")
      .bottomToolbar(title: "New Folder", systemImage: "plus") {
        print("Tapped")
      }
  }
}

struct BottomToolbarContentView_Previews: PreviewProvider {
  static var previews: some View {
    BottomToolbarContentView()
  }
}
