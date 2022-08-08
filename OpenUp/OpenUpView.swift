//
//  ContentView.swift
//  OpenUp
//
//  Created by José Tony on 05/07/22.
//

import SwiftUI
import AVKit

struct OpenUpView: View {
  @EnvironmentObject var signInVM: SignInViewModel
  @AppStorage("loggedUserUID") var loggedUserUID: String = ""
  
  var body: some View {
    ZStack {
      if !loggedUserUID.isEmpty {
//        Text(loggedUserUID)
        HomeView()
      } else {
        SignInScreen()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    OpenUpView()
  }
}


