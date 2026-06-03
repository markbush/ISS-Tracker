//
//  ContentView.swift
//  ISS Tracker
//
//  Created by Mark Bush on 03/06/2026.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var viewModel = ISSViewModel()
  
  var body: some View {
    ZStack(alignment: .bottom) {
      ISSMapView(viewModel: viewModel)
        .ignoresSafeArea()
      
      ISSInfoView(viewModel: viewModel)
    }
  }
}

#Preview {
    ContentView()
}
