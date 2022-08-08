//
//  User.swift
//  OpenUp
//
//  Created by José Tony on 30/07/22.
//

import Foundation

struct UserModel {
  let id: String
  let name: String
  let email: String
  let photoURL: URL!
}

extension UserModel {
  func toDictionary() -> [String: Any] {
    
    var stringURL = "no-photo"
    if let url = self.photoURL {
      stringURL = url.absoluteString
    }
    
    
    return [
      "id": self.id,
      "name": self.name,
      "email": self.email,
      "photoURL": stringURL
    ]
  }
}
