//
//  OUAudioService.swift
//  OpenUp
//
//  Created by José Tony on 30/07/22.
//

import Foundation
import AVKit

final class OUAudioService {
  // creating instance for recording...
  private var recorder: AVAudioRecorder!
  private var session: AVAudioSession!
  
  // creating instance for playing...
  private var audioPlayer: AVAudioPlayer!
  
  func requestPermission(response: @escaping (Bool, Error?) -> ()) {
    do {
      self.session = AVAudioSession.sharedInstance()
      try self.session.setCategory(.playAndRecord)
      
      self.session.requestRecordPermission { status in
        response(status, nil)
      }
    }
    catch {
      response(false, error)
    }
  }
  
  func recordAudio(response: @escaping (URL?, Error?) -> ()) {
    do {
      let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      
      let filename = url.appendingPathComponent("\(UUID().uuidString).m4a")
      
      
      let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 12000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
      ]
      
      self.recorder = try AVAudioRecorder(url: filename, settings: settings)
      recorder.record()
      
      response(filename, nil)
    } catch {
      // TODO: add better error handling
      response(nil, error)
    }
  }
  
  func stopRecordingAudio(response: @escaping () -> ()) {
    self.recorder.stop()
    response()
  }
  
  func playAudio(url: URL, response: @escaping (Bool, Error?) -> ()) {
    do {
      self.audioPlayer = try AVAudioPlayer(contentsOf: url)
      self.audioPlayer.play()
      
      response(true, nil)
    } catch {
      response(false, error)
    }
  }
  
  func stopPlayingAudio(url: URL, response: @escaping (Bool, Error?) -> ()) {
    do {
      self.audioPlayer = try AVAudioPlayer(contentsOf: url)
      self.audioPlayer.stop()
      
      response(true, nil)
    } catch {
      response(false, error)
    }
  }
}
