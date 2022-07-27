//
//  ContentView.swift
//  OpenUp
//
//  Created by José Tony on 05/07/22.
//

import SwiftUI
import AVKit

struct OpenUpView: View {
  
  @State var record = false
  
  // creating instance for recording...
  @State var session: AVAudioSession!
  @State var recorder: AVAudioRecorder!
  @State var alert = false
  
  // Fech audios
  @State var audios: [URL] = []
  
  var body: some View {
    NavigationView {
      VStack {
        List(self.audios, id: \.self) { audio in
          Text(audio.relativeString)
        }
        
        Button {
          do {
            if self.record {
              self.recorder.stop()
              self.record.toggle()
              
              self.getAudios()
              return
            }
            
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            let filename = url.appendingPathComponent("myRcd\(self.audios.count + 1).m4a")
            
            let settings = [
              AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
              AVSampleRateKey: 12000,
              AVNumberOfChannelsKey: 1,
              AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            self.recorder = try AVAudioRecorder(url: filename, settings: settings)
            self.recorder.record()
            self.record.toggle()
          } catch {
            print(error.localizedDescription)
          }
          
        } label: {
          ZStack{
            
            Circle()
              .fill(Color.red)
              .frame(width: 70, height: 70)
            
            if self.record{
              
              Circle()
                .stroke(Color.white, lineWidth: 6)
                .frame(width: 85, height: 85)
            }
          }
        }
        
      }
      .navigationTitle("Open Up")
    }
    .alert(isPresented: self.$alert) {
      Alert(title: Text("Error"), message: Text("Enable to acess"))
    }
    .onAppear {
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

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    OpenUpView()
  }
}

