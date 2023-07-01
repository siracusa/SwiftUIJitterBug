//
//  DemoView.swift
//  SwiftUIJitterBug
//
//  Created by John Siracusa on 6/24/23.
//

import SwiftUI

struct DemoView : View {
    @ObservedObject var appState : AppState

    var body : some View {
        let size = self.appState.iconSize.rounded()

        return VStack(spacing: 0) {
            ForEach(appState.items) { item in
                let _ = self.appState.redrawDelayEnabled ? usleep(self.appState.redrawDelay) : 0
                Image(systemName: item.image)
                    .resizable()
                    .padding(15)
                    .frame(
                        width: size,
                        height: size,
                        alignment: .topLeading
                    )
                    .background(.green)
            }
        }
        .background(
            GeometryReader { geo in
                Rectangle()
                .onAppear {
                    appState.viewSize = geo.size
                }
                .onChange(of: geo.size) { newSize in
                    appState.viewSize = newSize
                }
            }
        )
    }
}
