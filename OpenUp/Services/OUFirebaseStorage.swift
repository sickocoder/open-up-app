//
//  OUFirebaseStorage.swift
//  OpenUp
//
//  Created by José Tony on 08/08/22.
//

import Foundation
import FirebaseStorage

final class OUFirebaseStorage {
  let storage: Storage
  let firestoreService: OUFirebaseFirestore
  
  init(firestoreService: OUFirebaseFirestore) {
    self.storage = Storage.storage()
    self.firestoreService = firestoreService
  }
  
  func save(withURL url: URL, forUser userID: String, completion: @escaping (Error?) -> Void) {
    let storageRef = self.storage.reference()
    let userStorageRef = storageRef.child(userID)
    
    let uniqueAudioName = UUID().uuidString.lowercased()
    
    let audiosStorageRef = userStorageRef.child("audios/\(uniqueAudioName).m4a")
    
    audiosStorageRef.putFile(from: url) { storageMetadata, error in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      
      guard storageMetadata != nil else {
        print("something went wrong")
        return
      }
      
      audiosStorageRef.downloadURL { url, error in
        if let error = error {
          print(error.localizedDescription)
          return
        }
        
        guard let url = url else {
          print("didnt get the url")
          return
        }
        
        self.firestoreService.saveAudio(data: [
          "id": uniqueAudioName,
          "ownerID": userID,
          "downloadUrl": url.absoluteString,
          "createdAt": Date().millisecondsSince1970
        ], onPath: uniqueAudioName) {
          print("File Uploaded")
          completion(nil)
        }
      }
    }
  }
}
