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
        let size = self.appState.iconSize

        return VStack(spacing: 0) {
            ForEach(appState.items) { item in
                Image(systemName: item.image)
                    .resizable()
                    .padding(15)
                    .frame(
                        width: size,
                        height: size
                    )
                    .background(.green)
            }
        }
    }
}
