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
#if os(iOS)
    ContentNavigationView()
#else
    ContentTabView()
#if os(visionOS)
      .glassBackgroundEffect()
#endif
#endif
  }
}

#Preview {
  ContentView()
    .environment(ISSViewModel())
}

