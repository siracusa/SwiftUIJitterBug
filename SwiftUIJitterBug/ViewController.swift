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
    @IBOutlet weak var deltaField: NSTextField!
    @IBOutlet weak var maxDeltaField: NSTextField!
    @IBOutlet weak var redrawDelayCheckbox: NSButton!
    @IBOutlet weak var resetButton: NSButton!
    @IBOutlet weak var redrawDelayTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.appDelegate = (NSApplication.shared.delegate as! AppDelegate)
        self.appState = self.appDelegate.appState
        self.appState.viewController = self

        self.updateControls()
    }

    func updateControls() {
        self.slider.doubleValue = Double(self.appState.iconSize)

        self.deltaField.stringValue = String(format: "(%0.2f, %0.2f)", self.appState.sizeDelta.width, self.appState.sizeDelta.height)
        self.maxDeltaField.stringValue = String(format: "(%0.2f, %0.2f)", self.appState.maxSizeDelta.width, self.appState.maxSizeDelta.height)
        
        self.redrawDelayCheckbox.state = self.appState.redrawDelayEnabled ? .on : .off
        self.redrawDelayTextField.intValue = Int32(self.appState.redrawDelay)

        if self.appState.redrawDelayEnabled {
            self.redrawDelayTextField.isEnabled = true
        }
        else {
            self.redrawDelayTextField.isEnabled = false
        }
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

    @IBAction func resetButtonClicked(_ sender: Any) {
        self.appState.sizeDelta = .zero
        self.appState.maxSizeDelta = .zero
        self.updateControls()
    }

    @IBAction func redrawDelayCheckboxClicked(_ sender: Any) {
        self.appState.redrawDelayEnabled = self.redrawDelayCheckbox.state == .on
        self.updateControls()
    }

    @IBAction func redrawDelatTextFieldUpdated(_ sender: Any) {
        self.appState.redrawDelay = UInt32(self.redrawDelayTextField.intValue)
    }
}
