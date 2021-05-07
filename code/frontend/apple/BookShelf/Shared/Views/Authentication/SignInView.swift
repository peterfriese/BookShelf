//
//  SignInView.swift
//  BookShelf (iOS)
//
//  Created by Peter Friese on 07.05.21.
//

import SwiftUI
import AuthenticationServices
import Firebase
import CryptoKit

struct SignInView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @State private var currentNonce: String?
  
  var body: some View {
    VStack {
      Image("Logo")
        .resizable()
        .frame(width: 200, height: 200, alignment: .center)
        .cornerRadius(20)
        .aspectRatio(contentMode: .fit)
        .padding(.horizontal, 100)
        .padding(.vertical, 50)
      
      HStack {
        Text("Welcome to")
          .font(.title)
        
        Text("BookShelf")
          .font(.title)
          .fontWeight(.semibold)
      }
      Text("Create an account to save your books and access them anywhere.")
        .font(.headline)
        .fontWeight(.medium)
        .multilineTextAlignment(.center)
        .padding(20)
      
      Spacer()
      
      SignInWithAppleButton(
        onRequest: { request in
          let nonce = randomNonceString()
          currentNonce = nonce
          request.requestedScopes = [.fullName, .email]
          request.nonce = sha256(nonce)
        },
        onCompletion: { result in
          switch result {
          case .success(let authResults):
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
              
              guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
              }
              guard let appleIDToken = appleIDCredential.identityToken else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
              }
              guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
              }
              
              let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
              Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                  // Error. If error.code == .MissingOrInvalidNonce, make sure
                  // you're sending the SHA256-hashed nonce as a hex string with
                  // your request to Apple.
                  print(error?.localizedDescription as Any)
                  return
                }
                print("signed in")
                self.presentationMode.wrappedValue.dismiss()
              }
              
              print("\(String(describing: Auth.auth().currentUser?.uid))")
            default:
              break
              
            }
          default:
            break
          }
        }
      )
      .frame(width: 280, height: 45, alignment: .center)
      
      // other buttons will go here
      
      Divider()
        .padding(.horizontal, 15.0)
        .padding(.top, 20.0)
        .padding(.bottom, 15.0)
      
      
      Text("By using BookShelf you agree to our Terms of Use and Service Policy")
        .padding()
        .multilineTextAlignment(.center)
    }

  }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: Array<Character> =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length
  
  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
      }
      return random
    }
    
    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }
      
      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }
  
  return result
}

@available(iOS 13, *)
private func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
    return String(format: "%02x", $0)
  }.joined()
  
  return hashString
}


struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    Text("Hello")
      .sheet(isPresented: .constant(true), content: {
        SignInView()
      })
  }
}
