//
//  BackgroundScene.swift
//  SubdivisionSaver
//
//  Created by Eskil Sviggum on 19/02/2023.
//

import SpriteKit

class BackgroundScene: SKScene {
    
    let store: Store
    let node: SKScene
    
    init(store: Store, node: SKScene, size: CGSize) {
        self.store = store
        self.node = node
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.backgroundColor = store.backgroundColor
        self.scaleMode = .aspectFill
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.addChild(node)
        updateSize()
        node.didMove(to: view)
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        updateSize()
    }
    
    private func updateSize() {
        let size = min(self.size.width, self.size.height)
        node.size = CGSize(width: size, height: size)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        node.update(currentTime)
    }
    
}

