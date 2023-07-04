//
//  HostingView.swift
//  SwiftUIJitterBug
//
//  Created by John Siracusa on 6/27/23.
//

import Foundation
import SwiftUI

class HostingView : NSHostingView<DemoView> {
    override func layout() {
        super.layout()

        let viewSize = self.rootView.appState.viewSize

        if viewSize.width != 0 && self.frame.size != viewSize {
            self.rootView.appState.sizeDelta =
                CGSize(
                    width: self.frame.size.width - viewSize.width,
                    height: self.frame.size.height - viewSize.height
                )
        }
        else {
            self.rootView.appState.sizeDelta = .zero
        }
    }
}

class HostingViewController: NSHostingController<DemoView> {
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        let viewSize = self.rootView.appState.viewSize

        if viewSize.width != 0 && self.view.frame.size != viewSize {
            self.rootView.appState.sizeDelta =
                CGSize(
                    width: self.view.frame.size.width - viewSize.width,
                    height: self.view.frame.size.height - viewSize.height
                )
        }
        else {
            self.rootView.appState.sizeDelta = .zero
        }
    }
}

