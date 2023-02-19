//
//  SubdivisionSaverView.swift
//  SubdivisionSaver
//
//  Created by Eskil Sviggum on 19/02/2023.
//

import SpriteKit
import ScreenSaver

class SubdivisionSaverView: ScreenSaverView {
    
    let store = Store()
    let size = CGSize(width: 1000, height: 1000)
    let scene: SKScene
    var isPreviewApplication: Bool = false
    var hasDrawed: Bool = false
    
    lazy var configureSheetController = ConfigureSheetController()
    
    var skViews = [SKView]()
    
    override init?(frame: NSRect, isPreview: Bool) {
        let size = min(self.size.width, self.size.height)
        let subdivisionScene = SubdivisionScene(store: store, size: store.polygonCoversScreen ? frame.size : CGSize(width: size, height: size))
        self.scene = subdivisionScene
        
        super.init(frame: frame, isPreview: isPreview)
    }
    
    required convenience init?(coder: NSCoder) {
        let frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
        self.init(frame: frame, isPreview: false)
        isPreviewApplication = true
    }
    
    override func draw(_ rect: NSRect) {
        super.draw(rect)
        
        store.backgroundColor.set()
        rect.fill()
        
        let size = min(self.size.width, self.size.height)
        let center = CGPoint(x: (rect.width - size) / 2, y: (rect.height - size) / 2)
        let newRect = store.polygonCoversScreen ? rect : CGRect(x: rect.minX + center.x, y: rect.minY + center.y, width: size, height: size)

        if hasDrawed && isPreviewApplication {
            skViews.forEach { skView in
                skView.frame = newRect
            }
            return
        }

        let skView = SKView(frame: newRect)
        skView.allowsTransparency = true
        skView.wantsLayer = true
        skView.layer?.backgroundColor = store.backgroundColor.cgColor
        skViews.append(skView)
        self.addSubview(skView)
        skView.presentScene(scene)
        hasDrawed = true
    }
    
    
    override var hasConfigureSheet: Bool {
        return true
    }
    
    override var configureSheet: NSWindow? {
        configureSheetController.window
    }
    
}
