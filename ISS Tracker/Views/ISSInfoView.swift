//
//  ISSInfoView.swift
//  ISS Tracker
//
//  Created by Mark Bush on 03/06/2026.
//

import SwiftUI

struct ISSInfoView: View {
  @Environment(ISSViewModel.self) private var viewModel

  var body: some View {
    HStack(alignment: .center) {
      ISSStatView(title: "Lat", value: String(format: "%.2f°", viewModel.latitude))
      ISSStatView(title: "Long", value: String(format: "%.2f°", viewModel.longitude))
      ISSStatView(title: "Alt", value: String(format: "%.0f km", viewModel.altitude))
      ISSStatView(title: "Speed", value: String(format: "%.2f km/s", viewModel.speed))
      ISSStatView(title: "ISS Time", value: viewModel.localTime)
    }
    .padding(.vertical, 8)
    .padding(.horizontal, 4)
    .background(.ultraThinMaterial)
    .cornerRadius(8)
    .padding(.horizontal)
    .padding(.bottom, 8)
  }
}


#Preview {
  ISSInfoView()
    .environment(ISSViewModel())
}
