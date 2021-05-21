//
//  SettingsView.swift
//  BookShelf (iOS)
//
//  Created by Peter Friese on 07.05.21.
//

import SwiftUI
import Firebase
import Combine

struct SettingsView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var authenticationService: AuthenticationService
  
  var body: some View {
    NavigationView {
      VStack {
        Image("Logo")
          .resizable()
          .frame(width: 100, height: 100)
          .aspectRatio(contentMode: .fit)
          .padding(.horizontal, 100)
          .padding(.top, 20)
        
        Text("Thanks for managing your books with ")
          .font(.title)
          .multilineTextAlignment(.center)
        
        Text("BookShelf")
          .font(.title)
          .fontWeight(.semibold)
        
        Form {
          Section {
            HStack {
              Image("Logo")
                .resizable()
                .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
              Text("App Icon")
              Spacer()
              Text("Plain")
            }
          }
          
          Section {
            HStack {
              Image("Siri")
                .resizable()
                .frame(width: 17, height: 17)
              Text("Siri")
            }
          }
          
          Section {
            HStack {
              Image(systemName: "questionmark.circle")
              Text("Help & Feedback")
            }
            NavigationLink(destination: Text("About") ) {
              HStack {
                Image(systemName: "info.circle")
                Text("About")
              }
            }
            #if DEBUG
            HStack {
              Image(systemName: "bolt")
              Button("Crash the app") {
                fatalError("Force-crashed the app")
              }
            }
            #endif
          }
          
          AccountSection()
        }
        .navigationBarTitle("Settings", displayMode: .inline)
        .navigationBarItems(trailing:
                              Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                                Text("Done")
                              })
      }
    }
  }
}

struct AccountSection: View {
  @EnvironmentObject var authenticationService: AuthenticationService
  @State private var showSignInView = false
  
  var body: some View {
    Section(footer: footer) {
      button
    }
  }
  
  var footer: some View {
    HStack {
      Spacer()
      if authenticationService.user == nil {
        Text("You're not logged in.")
      }
      else {
        VStack {
          Text("Thanks for using BookShelf!")
          Text("You are logged in.")
        }
      }
      Spacer()
    }
  }
  
  var button: some View {
    VStack {
      if authenticationService.isSignedIn {
        Button(action: logout) {
          HStack {
            Spacer()
            Text("Logout")
            Spacer()
          }
        }
      }
      else {
        Button(action: login) {
          HStack {
            Spacer()
            Text("Login")
            Spacer()
          }
        }
      }
    }
    .sheet(isPresented: $showSignInView) {
      SignInView()
    }
  }
  
  func login() {
    showSignInView.toggle()
  }
  
  func logout() {
    authenticationService.signOut()
  }
  
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SettingsView()
      SettingsView()
        .preferredColorScheme(.dark)
    }
  }
}

