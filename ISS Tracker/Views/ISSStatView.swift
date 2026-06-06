//
//  ISSStatView.swift
//  ISS Tracker
//
//  Created by Mark Bush on 03/06/2026.
//

import SwiftUI

struct ISSStatView: View {
  let title: String
  let value: String
  
  var body: some View {
    VStack(spacing: 4) {
      Text(title)
        .font(.title3)
//        .foregroundColor(.secondary)
      Text(value)
        .font(.headline)
        .monospacedDigit()
    }
    .foregroundStyle(.white)
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  ISSStatView(title: "Latitude", value: "51.5074°")
    .background(Color(red: 0.0, green: 0, blue: 1))
}
