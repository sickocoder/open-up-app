//
//  File.swift
//  OpenUp
//
//  Created by José Tony on 27/07/22.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseFirestore

final class SignInViewModel: ObservableObject {
  
  @AppStorage("loggedUserUID") var loggedUserUID: String = ""
  
  @Published var isLoggedIn: Bool  = false
  @Published var user: UserModel!
  
  private let firestoreService: OUFirebaseFirestore
  
  init(firestoreService: OUFirebaseFirestore) {
    self.firestoreService = firestoreService
  }
  
  func signInWithGoogle(response: @escaping (UserModel?, Error?) -> ()) {
    // get app client id
    guard let clientID = FirebaseApp.app()?.options.clientID else { return }
    
    // get configuration
    let config = GIDConfiguration(clientID: clientID)
    
    // sign-in
    GIDSignIn.sharedInstance.signIn(with: config, presenting: ApplicationUtility.rootViewController) {
      [self] user, err in
      
      if let error = err {
        response(nil, error)
        return
      }
      
      guard
        let authentication = user?.authentication,
        let idToken = authentication.idToken
      else { return }
      
      let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
      
      Auth.auth().signIn(with: credential) { result, error in
        if let err = error {
          response(nil, err)
          return
        }
        
        guard let user = result?.user else {
          response(nil, nil)
          return
        }
        
        self.user = UserModel(
          id: user.uid,
          name: user.displayName ?? "",
          email: user.email ?? "",
          photoURL: user.photoURL
        )
        
        self.firestoreService.saveData(self.user.toDictionary(), onCollection: .users, andDocument: user.uid) { error in
          
          if let error = error {
            response(nil, error)
            print("couldnt save user data")
            return
          }
          
          self.isLoggedIn.toggle()
          self.loggedUserUID = user.uid
          
          response(self.user, nil)
          
        }
        
      }
    }
  }
}
