//
//  ConfigureSheetController.swift
//  SubdivisionSaver
//
//  Created by Eskil Sviggum on 19/02/2023.
//

import Cocoa

class ConfigureSheetController: NSObject {
    
    @IBOutlet var window: NSWindow!
    @IBOutlet var backgroundColorWell: NSColorWell!
    @IBOutlet var foregroundColorWell: NSColorWell!
    @IBOutlet var polygonLabel: NSTextField!
    @IBOutlet var recursionLevelLabel: NSTextField!
    @IBOutlet var recursionLevelStepper: NSStepper!
    @IBOutlet var polygonStepper: NSStepper!
    @IBOutlet var polygonCoversScreenCheckbox: NSButton!
    @IBOutlet var rotatesCheckbox: NSButton!
    
    var store = Store()
    
    @objc
    var background: NSColor = .white {
        didSet {
            store.backgroundColor = background
        }
    }
    
    @objc
    var foreground: NSColor = .white {
        didSet {
            store.foregroundColor = foreground
        }
    }
    
    @objc
    var polygon: Int = 0 {
        didSet {
            store.polygon = polygon
        }
    }
    
    @objc
    var recursionLevel: Int = 0 {
        didSet {
            store.recursionLevel = recursionLevel
        }
    }
    
    @objc
    var polygonCoversScreen: Bool = false {
        didSet {
            store.polygonCoversScreen = polygonCoversScreen
        }
    }
    
    @objc
    var rotates: Bool = false {
        didSet {
            store.rotates = rotates
        }
    }
    
    override init() {
        super.init()
        
        let bundle = Bundle(for: ConfigureSheetController.self)
        bundle.loadNibNamed(.init("ConfigureSheet"), owner: self, topLevelObjects: nil)
        
        configureValues()
    }
    
    func configureValues() {
        backgroundColorWell.color = store.backgroundColor
        foregroundColorWell.color = store.foregroundColor
        polygonLabel.stringValue = "\(store.polygon)"
        recursionLevelLabel.stringValue = "\(store.recursionLevel)"
        recursionLevelStepper.integerValue = store.recursionLevel
        polygonStepper.integerValue = store.polygon
        polygonCoversScreenCheckbox.state = store.polygonCoversScreen ? .on : .off
        rotatesCheckbox.state = store.rotates ? .on : .off
        
        polygon = store.polygon
        recursionLevel = store.recursionLevel
        polygonCoversScreen = store.polygonCoversScreen
        rotates = store.rotates
    }
    
    @IBAction func close(sender: Any?) {
        NSApp.endSheet(window)
        window.close()
    }
    
    @IBAction func reset(sender: NSButton) {
        store.resetValues()
        configureValues()
    }
    
}
