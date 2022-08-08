//
//  OUFirebaseFirestore.swift
//  OpenUp
//
//  Created by José Tony on 08/08/22.
//

import Foundation
import FirebaseFirestore

final class OUFirebaseFirestore {
  
  // TODO: find a better way to write this...
  func saveData(_ data: [String: Any], onCollection colletion: OUFirestoreColletions, andDocument document: String?, completion: @escaping (Error?) -> Void) {
    let database = Firestore.firestore()
    
    if let document = document {
      database.collection(colletion.rawValue).document(document).setData(data) { error in
        completion(error)
      }
    } else {
      database.collection(colletion.rawValue).addDocument(data: data) { error in
        completion(error)
      }
    }
  }
  
  func saveAudio(data: [String: Any], onPath path: String, completion: @escaping () -> Void) {
    
    self.saveData(data, onCollection: .audios, andDocument: path) { error in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      
      completion()
      
    }
  }
}
