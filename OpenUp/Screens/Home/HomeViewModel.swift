//
//  HomeViewController.swift
//  OpenUp
//
//  Created by José Tony on 27/07/22.
//

import Foundation
import AVKit

final class HomeViewModel: ObservableObject {
  @Published var audios: [URL] = []
  @Published var currentPlayingAudioURL: URL!
  @Published var currentRecordingAudioURL: URL!
  
  @Published var isRecording = false
  @Published var shouldShowAlert = false
  @Published var isPlaying = false
  
  private let audioService: OUAudioService = OUAudioService()
  private let storageService = OUFirebaseStorage(firestoreService: OUFirebaseFirestore())
  
  func requestPermission() {
    self.audioService.requestPermission { status, error in
      if let err = error {
        print(err.localizedDescription)
        return
      }
      
      if !status {
        self.shouldShowAlert.toggle()
      } else {
        self.getAudios()
      }
    }
  }
  
  func recordAudio() {
    
    self.audioService.recordAudio { fileURL, err in
      if let error = err {
        print(error.localizedDescription)
        return
      }
      
      self.currentRecordingAudioURL = fileURL
      self.isRecording = true
    }
  }
  
  func stopRecordingAudio(userID: String) {
    self.audioService.stopRecordingAudio {
      self.isRecording.toggle()
      self.getAudios()
      
      
      
      self.storageService.save(withURL: self.currentRecordingAudioURL, forUser: userID) { error in
        if let error = error {
          print(error.localizedDescription)
          return
        }
      }
    }
  }
  
  func playAudio(url: URL) {
    if self.isPlaying {
      self.audioService.stopPlayingAudio(url: url) { didStop, error in
        if let error = error {
          print(error.localizedDescription)
          return
        }
        
        self.isPlaying = didStop
      }
    } else {
      self.audioService.playAudio(url: url) { isPlaying, error in
        if let error = error {
          print(error.localizedDescription)
          return
        }
        
        self.isPlaying = isPlaying
      }
      
      self.currentPlayingAudioURL = nil
    }
  }
  
  // Get audios list from firebase
  func getAudios() {
    do {
      let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      
      let result = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
      
      self.audios.removeAll()
      
      for audioUrl in result {
        self.audios.append(audioUrl)
      }
    }
    catch {
      print(error.localizedDescription)
    }
  }
  
}
