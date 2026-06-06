//
//  ISS_TrackerApp.swift
//  ISS Tracker
//
//  Created by Mark Bush on 03/06/2026.
//

import SwiftUI

@main
struct ISS_TrackerApp: App {
  @State private var viewModel = ISSViewModel()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(viewModel)
    }
  }
}

