//
//  SettingsView.swift
//  ISS Tracker
//
//  Created by Mark Bush on 06/06/2026.
//

import SwiftUI

struct SettingsView: View {
  @Environment(ISSViewModel.self) private var viewModel
  @State private var displayUnits: DisplayUnits = .metric

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 24) {
        Text("Settings")
          .font(.headline)

        HStack {
          Text("Display Units:")
          
          Picker("", selection: $displayUnits) {
            Text("Metric").tag(DisplayUnits.metric)
            Text("Imperial").tag(DisplayUnits.imperial)
          }
          .onChange(of: displayUnits) {
            viewModel.displayUnits = displayUnits
          }
        }
      }
      .frame(maxWidth: .infinity)
      .padding(.top, 40)
      .padding(.horizontal, 40)
      .padding(.bottom, 40)
    }
    .onAppear {
      displayUnits = viewModel.displayUnits
    }
  }
}

#Preview {
  SettingsView()
    .environment(ISSViewModel())
}

