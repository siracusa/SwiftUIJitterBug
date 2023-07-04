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
//    var view : DemoView!
    var window : NSWindow!
    var appState = AppState()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let view = DemoView(appState: appState)
        
        self.window = NSWindow(
            contentRect: NSRect(),
            styleMask: [ .titled ],
            backing: .buffered,
            defer: false
        )
        
        let hostingController = HostingViewController(rootView: view)
        hostingController.sizingOptions = .preferredContentSize
        hostingController.view.wantsLayer = true
        hostingController.view.layer?.backgroundColor = NSColor.red.cgColor
        
        self.window.backgroundColor = .blue
        self.window.contentViewController = hostingController
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
                pos.x = visibleScreenFrame.origin.x + visibleScreenWidth - min(frame.size.width, visibleScreenWidth)
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
        return false
    }
}

enum WindowPositionCalculation : Int {
    case anchored = 1
    case centered = 2
}

struct Item : Identifiable {
    let id : UUID = UUID()
    let image : String
}

class AppState : ObservableObject {
    @Published var iconSize : CGFloat = 100
    @Published var items : [Item] = []

    @Published var redrawDelayEnabled = false
    @Published var redrawDelay : useconds_t = 1000

    var sizeDelta : CGSize = .zero
    var maxSizeDelta : CGSize = .zero

    weak var viewController : ViewController?

    var viewSize : CGSize = .zero {
        didSet {
            let delta = String(format: "(%0.2f, %0.2f)", self.sizeDelta.width, self.sizeDelta.height)
            self.viewController?.deltaField.stringValue = delta

            if abs(self.sizeDelta.width * self.sizeDelta.height) > abs(self.maxSizeDelta.width * self.maxSizeDelta.height) {
                self.maxSizeDelta = self.sizeDelta
                self.viewController?.maxDeltaField.stringValue = delta
            }
        }
    }
    
    var windowPositionCalculation : WindowPositionCalculation = .anchored

    init() {
        let screen = NSScreen.screens.first!

        // Try to get enough bugs to fit on the screen while
        // also being able to extend off the top/bottom of
        // the screen at the maximum zoom level.
        let numBugs = Int(screen.visibleFrame.height / 350)

        for _ in 1...numBugs {
            items.append(Item(image: "ladybug.fill"))
            items.append(Item(image: "ladybug"))
        }
    }
}
