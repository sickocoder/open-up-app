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
  
  @Published var isRecording = false
  @Published var shouldShowAlert = false
  @Published var isPlaying = false
  
  // creating instance for recording...
  private var recorder: AVAudioRecorder!
  private var session: AVAudioSession!
  
  // creating instance for playing...
  private var audioPlayer: AVAudioPlayer!
  
  func requestPermission() {
    do {
      self.session = AVAudioSession.sharedInstance()
      try self.session.setCategory(.playAndRecord)
      
      self.session.requestRecordPermission { status in
        if !status {
          self.shouldShowAlert.toggle()
        } else {
          self.getAudios()
        }
      }
    }
    catch {
      print(error.localizedDescription)
    }
  }
  
  func recordAudio() {
    do {
      let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      
      let filename = url.appendingPathComponent("myRcd\(self.audios.count + 1).m4a")
      
      let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 12000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
      ]
      
      self.recorder = try AVAudioRecorder(url: filename, settings: settings)
      recorder.record()
      self.isRecording.toggle()
    } catch {
      // TODO: add better error handling
      print(error.localizedDescription)
    }
  }
  
  func stopRecordingAudio() {
    self.recorder.stop()
    self.isRecording.toggle()
    
    self.getAudios()
  }
  
  func playAudio(url: URL) {
    do {
      self.audioPlayer = try AVAudioPlayer(contentsOf: url)
      
      if self.isPlaying {
        self.audioPlayer.stop()
        self.currentPlayingAudioURL = nil
      } else {
        self.audioPlayer.play()
        self.currentPlayingAudioURL = url
      }
      
      self.isPlaying.toggle()
    } catch {
      print("couldn't play the audio")
    }
  }
  
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
