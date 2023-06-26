//
//  ViewController.swift
//  SwiftUIJitterBug
//
//  Created by John Siracusa on 6/24/23.
//

import Cocoa

class ViewController: NSViewController {
    var appState : AppState!
    var appDelegate : AppDelegate!

    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var calcPopUp: NSPopUpButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.appDelegate = (NSApplication.shared.delegate as! AppDelegate)
        self.appState = self.appDelegate.appState

        self.slider.doubleValue = Double(self.appState.iconSize)
    }

    @IBAction func sliderChanged(_ sender: Any) {
        self.appState.iconSize = CGFloat(self.slider.floatValue)
    }
    
    @IBAction func calcPopUpChanged(_ sender: Any) {
        let tag = self.calcPopUp.selectedTag()

        if let calc = WindowPositionCalculation(rawValue: tag) {
            self.appState.windowPositionCalculation = calc
            self.appDelegate.setWindowPosition()
        }
        else {
            fatalError("Unknown window position calculation: \(tag)")
        }
    }
}
