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
  @Published var record = false
  @Published var alert = false
  
  // creating instance for recording...
  private var recorder: AVAudioRecorder!
  private var session: AVAudioSession!
  
  func requestPermission() {
    do {
      self.session = AVAudioSession.sharedInstance()
      try self.session.setCategory(.playAndRecord)
      
      self.session.requestRecordPermission { status in
        if !status {
          self.alert.toggle()
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
      self.record.toggle()
    } catch {
      // TODO: add better error handling
      print(error.localizedDescription)
    }
  }
  
  func stopRecordingAudio() {
    self.recorder.stop()
    self.record.toggle()
    
    self.getAudios()
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
