//
//  ContentTabView.swift
//  ISS Tracker
//
//  Created by Mark Bush on 06/06/2026.
//

import SwiftUI

#if !os(iOS)
struct ContentTabView: View {
  @Environment(ISSViewModel.self) private var viewModel

  var body: some View {
    TabView {
      Tab("ISS", systemImage: "map") {
        ISSView()
      }
      Tab("About", systemImage: "info.circle") {
        AboutView()
      }
      Tab("Settings", systemImage: "gear") {
        SettingsView()
      }
    }
  }
}

#Preview {
  ContentTabView()
    .environment(ISSViewModel())
}
#endif

