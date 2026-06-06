//
//  AboutView.swift
//  ISS Tracker
//
//  Created by Mark Bush on 06/06/2026.
//

import SwiftUI

struct AboutView: View {
  @Environment(ISSViewModel.self) private var viewModel
  @State private var displayUnits: DisplayUnits = .metric

  private var appName: String {
    Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "ISS-Tracker"
  }
  
  private var version: String {
    Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0"
  }
  
  private var build: String {
    Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"
  }
  
  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        // App Icon Placeholder / Name
        HStack(spacing: 16) {
          AppIcon()
            .frame(width: 128, height: 128)
          
          VStack(spacing: 4) {
            Text(appName)
              .font(.largeTitle)
              .fontWeight(.bold)
            
            Text("by Mark Bush")
              .font(.title3)
              .foregroundColor(.secondary)
            
            Text("Version \(version) (\(build))")
              .font(.subheadline)
              .foregroundColor(.secondary)
          }
        }
        .padding(.top, 40)

        Divider()
          .padding(.horizontal, 40)
        
        VStack(alignment: .leading, spacing: 16) {
          Text("About")
            .font(.headline)
          
          Text("\(appName) allows you to track the current location of the International Space Station (ISS).")
            .lineSpacing(4)
          
          Text("Features:")
            .font(.subheadline)
            .fontWeight(.semibold)
          
          VStack(alignment: .leading, spacing: 8) {
            featureRow(icon: "dot.scope", text: "See the current location of the ISS.")
            featureRow(icon: "map", text: "View the region of the Earth where the ISS is currently visible.")
            featureRow(icon: "point.bottomleft.forward.to.point.topright.scurvepath", text: "See the previous and next 90 minutes of the ISS's location.")
          }
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 40)
#if os(tvOS)
        .frame(maxWidth: 900)
#else
        .frame(maxWidth: 600)
#endif
      }
    }
  }
  
  private func featureRow(icon: String, text: String) -> some View {
    HStack(alignment: .top, spacing: 12) {
      Image(systemName: icon)
        .foregroundColor(.accentColor)
        .frame(width: 24)
      Text(text)
        .font(.body)
    }
  }
}

#Preview {
  AboutView()
    .environment(ISSViewModel())
}

