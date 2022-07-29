//
//  SignInScreen.swift
//  OpenUp
//
//  Created by José Tony on 27/07/22.
//

import SwiftUI

struct SignInScreen: View {
  @EnvironmentObject var signInVM: SignInViewModel
  
  var body: some View {
    Button {
      signInVM.signInWithGoogle()
    } label: {
      Text("Sign In")
    }
  }
}

struct SignInScreen_Previews: PreviewProvider {
  static var previews: some View {
    SignInScreen()
  }
}

