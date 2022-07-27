//
//  PlayButton.swift
//  OpenUp
//
//  Created by José Tony on 27/07/22.
//

import SwiftUI

struct RecordButton: View {
  var isRecording: Bool
  
  var body: some View {
    ZStack{
      Circle()
        .fill(Color.red)
        .frame(width: 70, height: 70)
      
      if isRecording {
        Circle()
          .stroke(Color.white, lineWidth: 6)
          .frame(width: 85, height: 85)
      }
    }
  }
}

struct RecordButtonButton_Previews: PreviewProvider {
  static var previews: some View {
    RecordButton(isRecording: true)
  }
}
