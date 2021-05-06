//
//  SearchBarView.swift
//  SearchBar
//
//  Created by Peter Friese on 30.01.21.
//

import SwiftUI

import SwiftUI

struct SearchBar: View {
  @Binding var text: String
  @Binding var isEditing: Bool
  
  var onCommit: ((String) -> Void)?
  
  var cancelButton: some View {
    Button(action: cancelEditing) {
      Text("Cancel")
    }
    .padding(.trailing, 10)
    .transition(.move(edge: .trailing))
    .animation(.default)
  }
  
  var body: some View {
    HStack {
      TextField("Search...", text: $text) { isEditing in
        startEditing()
      } onCommit: {
        print("Committing with current text: \(text).")
        onCommit?(text)
      }
      .padding(7)
      .padding(.horizontal, 25)
      .background(Color(.secondarySystemBackground))
      .cornerRadius(8)
      .overlay(
        HStack {
          Image(systemName: "magnifyingglass")
            .foregroundColor(.gray)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 8)
          
          if isEditing && !text.isEmpty {
            Button(action: clear) {
              Image(systemName: "multiply.circle.fill")
                .foregroundColor(.gray)
                .padding(.trailing, 8)
            }
          }
        }
      )
      .padding(.horizontal, 10)
      .onTapGesture(perform: startEditing)
      
      if isEditing {
        cancelButton
      }
    }
  }
  
  func clear() {
    text = ""
  }
  
  func startEditing() {
    withAnimation {
      self.isEditing = true
    }
  }
  
  func cancelEditing() {
    clear()
    withAnimation {
      UIApplication.shared.endEditing(true)
      isEditing = false
    }
  }
}

extension UIApplication {
  func endEditing(_ force: Bool) {
    self.windows
      .filter{$0.isKeyWindow}
      .first?
      .endEditing(force)
  }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
  var gesture = DragGesture().onChanged{_ in
    UIApplication.shared.endEditing(true)
  }
  func body(content: Content) -> some View {
    content.gesture(gesture)
  }
}

extension View {
  func resignKeyboardOnDragGesture() -> some View {
    return modifier(ResignKeyboardOnDragGesture())
  }
}


struct SearchBarView_Previews: PreviewProvider {
  static var previews: some View {
    SearchBar(text: .constant(""), isEditing: .constant(true))
      .previewLayout(.sizeThatFits)
  }
}
