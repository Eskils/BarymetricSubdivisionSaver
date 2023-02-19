//
//  Store.swift
//  SubdivisionSaver
//
//  Created by Eskil Sviggum on 19/02/2023.
//

import ScreenSaver

class Store {
    
    private let defaultsId = "SubdivisionSaverStore"
    private lazy var defaults = ScreenSaverDefaults(forModuleWithName: defaultsId)!
    
    static let defaultForegroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    static let defaultBackgroundColor = #colorLiteral(red: 0.0, green: 0.1166428402, blue: 0.3413119018, alpha: 1.0)
    static let defaultRecursionLevel = 3
    static let defaultPolygon = 7
    static let defaultPloygonCoversScreen = false
    static let defaultRotates = false
    
    private func getValue<T: NSCoding & NSObject>(named name: String, type: T.Type, fallback: T) -> T {
        guard let encoded = defaults.data(forKey: name) else {
            NSLog("No data saved.")
            return fallback
        }
        
        do {
            let value = try NSKeyedUnarchiver.unarchivedObject(ofClass: type, from: encoded)
            guard let value else {
                return fallback
            }
            NSLog("Retrieved data \(value)")
            return value
            
        } catch {
            NSLog("Could not decode data: \(error)")
            return fallback
        }
    }
    
    private func setValue<T: NSCoding>(_ value: T, named name: String) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            NSLog("Saved data \(data)")
            defaults.set(data, forKey: name)
            defaults.synchronize()
        } catch {
            NSLog("Could not encode data: \(error)")
        }
    }
    
    var foregroundColor: NSColor {
        get {
            getValue(named: "foregroundColor", type: NSColor.self, fallback: Self.defaultForegroundColor)
        }
        set(value) {
            NSLog("Foreground color set")
            setValue(value, named: "foregroundColor")
        }
    }
    
    var backgroundColor: NSColor {
        get {
            getValue(named: "backgroundColor", type: NSColor.self, fallback: Self.defaultBackgroundColor)
        }
        set(value) {
            NSLog("Background color set")
            setValue(value, named: "backgroundColor")
        }
    }
    
    var recursionLevel: Int {
        get {
            let int = defaults.integer(forKey: "recursionLevel")
            if int == 0 {
                return Self.defaultRecursionLevel
            }
            return int
        }
        set(value) {
            defaults.set(value, forKey: "recursionLevel")
            defaults.synchronize()
        }
    }
    
    var polygon: Int {
        get {
            let int = defaults.integer(forKey: "polygon")
            if int == 0 {
                return Self.defaultPolygon
            }
            return int
        }
        set(value) {
            defaults.set(value, forKey: "polygon")
            defaults.synchronize()
        }
    }
    
    var polygonCoversScreen: Bool {
        get {
            defaults.bool(forKey: "polygonCoversScreen")
        }
        set(value) {
            defaults.set(value, forKey: "polygonCoversScreen")
            defaults.synchronize()
        }
    }
    
    var rotates: Bool {
        get {
            defaults.bool(forKey: "rotates")
        }
        set(value) {
            defaults.set(value, forKey: "rotates")
            defaults.synchronize()
        }
    }
    
    func resetValues() {
        self.defaults.dictionaryRepresentation().keys.forEach {
            self.defaults.removeObject(forKey: $0)
        }
        self.defaults.synchronize()
    }
    
    
}
