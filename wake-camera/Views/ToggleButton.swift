//
//  ToggleButton.swift
//  wake-camera
//
//  Created by Reona Ogino on 2023/01/19.
//

import SwiftUI

struct ToggleButton: View {
  @Binding var selected: Bool
  
  var label: String
  
  var body: some View {
    Button(action: {
      selected.toggle()
    }, label: {
      Text(label)
    })
    .padding(.vertical, 10)
    .padding(.horizontal)
    .foregroundColor(selected ? .white : .black)
    .background(selected ? Color.blue : .white)
    .animation(.easeInOut, value: 0.25)
    .cornerRadius(10)
  }
}

struct ToggleButton_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color.black
      
      ToggleButton(selected: .constant(false), label: "Toggle")
    }
  }
}
