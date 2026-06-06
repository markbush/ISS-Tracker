//
//  ContentView.swift
//  ISS Tracker
//
//  Created by Mark Bush on 03/06/2026.
//

import SwiftUI

struct ContentView: View {
  @Environment(ISSViewModel.self) private var viewModel
  
  var body: some View {
    ISSView()
  }
}

#Preview {
  ContentView()
    .environment(ISSViewModel())
}

