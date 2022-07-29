//
//  File.swift
//  OpenUp
//
//  Created by José Tony on 27/07/22.
//

import SwiftUI
import Firebase
import GoogleSignIn

final class SignInViewModel: ObservableObject {
  
  @Published var isLoggedIn: Bool  = false
  
  func signInWithGoogle() {
    // get app client id
    guard let clientID = FirebaseApp.app()?.options.clientID else { return }
    
    // get configuration
    let config = GIDConfiguration(clientID: clientID)
    
    // sign-in
    GIDSignIn.sharedInstance.signIn(with: config, presenting: ApplicationUtility.rootViewController) {
      [self] user, err in
      
      if let error = err {
        print(error.localizedDescription)
        return
      }
      
      guard
        let authentication = user?.authentication,
        let idToken = authentication.idToken
      else { return }
      
      let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
      
      Auth.auth().signIn(with: credential) { result, error in
        if let err = error {
          print(err.localizedDescription)
          return
        }
        
        guard let user = result?.user else { return }
        print(user.displayName)
        
        self.isLoggedIn.toggle()
      }
    }
  }
}
