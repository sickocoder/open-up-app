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
          Text(audio.relativeString)
        }
        
        Button {
          if viewModel.record {
            viewModel.stopRecordingAudio()
            return
          }
          
          viewModel.recordAudio()
        } label: { RecordButton(isRecording: viewModel.record) }
        
      }
      .navigationTitle("Open Up")
    }
    .alert(isPresented: $viewModel.alert) {
      Alert(title: Text("Error"), message: Text("Enable to access"))
    }
    .onAppear { viewModel.requestPermission() }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}

