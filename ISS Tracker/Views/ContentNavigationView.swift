//
//  ContentNavigationView.swift
//  ISS Tracker
//
//  Created by Mark Bush on 06/06/2026.
//

import SwiftUI

#if os(iOS)
struct ContentNavigationView: View {
  @Environment(ISSViewModel.self) private var viewModel
  
  var body: some View {
    @Bindable var viewModel = viewModel

    NavigationSplitView {
      List(selection: $viewModel.selectedSidebarItem) {
        NavigationLink(value: ISSViewModel.SidebarItem.map) {
          Label("ISS", systemImage: "map")
        }
        NavigationLink(value: ISSViewModel.SidebarItem.about) {
          Label("About", systemImage: "info.circle")
        }
        NavigationLink(value: ISSViewModel.SidebarItem.settings) {
          Label("Settings", systemImage: "gear")
        }
      }
      .navigationSplitViewColumnWidth(min: 100, ideal: 220, max: 280)
    } detail: {
      switch viewModel.selectedSidebarItem {
        case nil, .map:
          NavigationStack {
            ISSView()
          }
        case .about:
          NavigationStack {
            AboutView()
          }
        case .settings:
          NavigationStack {
            SettingsView()
          }
      }
    }
  }
}

#Preview {
  ContentNavigationView()
    .environment(ISSViewModel())
}
#endif


