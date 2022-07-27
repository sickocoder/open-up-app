//
//  HomeView.swift
//  OpenUp
//
//  Created by José Tony on 27/07/22.
//

import SwiftUI

struct HomeView: View {
  @ObservedObject var viewModel = HomeViewModel()
  
  var body: some View {
    NavigationView {
      VStack {
        List(viewModel.audios, id: \.self) { audio in
          HStack {
            Image(systemName: viewModel.currentPlayingAudioURL == audio.absoluteURL ? "stop.fill" : "play.fill")
            Text(audio.relativeString)
              .onTapGesture {
                viewModel.playAudio(url: audio.absoluteURL)
              }
          }
        }
        
        Button {
          if viewModel.isRecording {
            viewModel.stopRecordingAudio()
            return
          }
          
          viewModel.recordAudio()
        } label: {
          RecordButton(isRecording: viewModel.isRecording)
          
        }
        .disabled(viewModel.isPlaying)
        
      }
      .navigationTitle("Open Up")
    }
    .alert(isPresented: $viewModel.shouldShowAlert) {
      Alert(title: Text("Error"), message: Text("Enable to access the microphone"))
    }
    .onAppear { viewModel.requestPermission() }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}

