//
//  ISSView.swift
//  ISS Tracker
//
//  Created by Mark Bush on 06/06/2026.
//

import SwiftUI

struct ISSView: View {
  @Environment(ISSViewModel.self) private var viewModel

  var body: some View {
    ZStack(alignment: .bottom) {
      ISSMapView()
        .ignoresSafeArea()
      
      ISSInfoView()
      
      if !viewModel.tleAvailable {
        VStack {
          Spacer()
          VStack(alignment: .center) {
            Text("Cannot load ISS location data.")
            Text("Please check your internet connection.")
          }
          .font(.title)
          .foregroundColor(.secondary)
          .padding(8)
          .background(Color.yellow)
          .cornerRadius(8)
          Spacer()
        }
      }
    }
  }
}

#Preview {
  ISSView()
    .environment(ISSViewModel())
}

