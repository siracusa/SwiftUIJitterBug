//
//  AppDelegate.swift
//  SwiftUIJitterBug
//
//  Created by John Siracusa on 6/24/23.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var view : DemoView!
    var window : NSWindow!
    var appState = AppState()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.view = DemoView(appState: self.appState)

        self.window = NSWindow(
            contentRect: NSRect(),
            styleMask: [ .titled ],
            backing: .buffered,
            defer: false
        )

        self.window.contentView = NSHostingView(rootView: self.view)
        self.window.delegate = self

        self.setWindowPosition()
        self.window.orderFront(self)
    }

    func setWindowPosition() {
        let frame = self.window.frame
        let screen = NSScreen.screens.first!

        let screenFrame = screen.frame
        let screenHeight = screenFrame.size.height

        let visibleScreenFrame = screen.visibleFrame
        let visibleScreenHeight = visibleScreenFrame.size.height
        let visibleScreenWidth = visibleScreenFrame.size.width

        let menuBarHeight = NSApplication.shared.mainMenu?.menuBarHeight ?? 24

        var pos = NSPoint()
        
        switch self.appState.windowPositionCalculation {
            case .anchored:
                pos.x = visibleScreenFrame.origin.x + visibleScreenWidth - min(frame.size.width, visibleScreenWidth) - 15
                pos.y = visibleScreenFrame.origin.y + visibleScreenHeight - frame.size.height
            case .centered:
                pos.x = visibleScreenFrame.origin.x + visibleScreenWidth - min(frame.size.width, visibleScreenWidth)
                pos.y = screenFrame.origin.y + ((screenHeight - menuBarHeight) / 2) - (frame.size.height / 2)
        }

        self.window.setFrameOrigin(pos)
    }

    func windowDidResize(_ notification: Notification) {
        self.setWindowPosition()
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

enum WindowPositionCalculation : Int {
    case anchored = 1
    case centered = 2
}

class AppState : ObservableObject {
    @Published var iconSize : CGFloat = 100
    @Published var items : [String] = []

    var windowPositionCalculation : WindowPositionCalculation = .anchored

    init() {
        let screen = NSScreen.screens.first!

        // Try to get enough bugs to fit on the screen while
        // also being able to extend off the top/bottom of
        // the screen at the maximum zoom level.
        let numBugs = Int(screen.visibleFrame.height / 350)

        for _ in 1...numBugs {
            items.append("ladybug.fill")
            items.append("ladybug")
        }
    }
}
