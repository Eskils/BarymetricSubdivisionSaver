//
//  SubdivisionScene.swift
//  Barymetric Subdivision
//
//  Created by Eskil Sviggum on 18/02/2023.
//

import SpriteKit

class SubdivisionScene: SKScene {
    
    let store: Store
    var recursionLevel = 3
    var foreground: NSColor = Store.defaultForegroundColor
    var background: NSColor = Store.defaultBackgroundColor
    var rotates = false
    var points: [DPoint] = .regularPolygon(n: 7)
    var edges: [Edge] = []
    
    var shapeNodeIndex: Int = 0
    var shapeNodes = [SKShapeNode]()
    var shapeNode: SKShapeNode?
    
    var pointRadius: CGFloat = 1
    lazy var scale = self.size.width / 3
    var subdivideTime: Double = 0
    
    init(store: Store, size: CGSize) {
        self.store = store
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)

        self.recursionLevel = store.recursionLevel
        self.points = .regularPolygon(n: Double(store.polygon))
        self.background = store.backgroundColor
        self.foreground = store.foregroundColor
        self.rotates = store.rotates
        
        if store.polygonCoversScreen {
            self.points = [
                DPoint(x: 0, y: 0),
                DPoint(x: size.width, y: 0),
                DPoint(x: size.width, y: size.height),
                DPoint(x: 0, y: size.height)
            ]
        }
        
        self.backgroundColor = .clear
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scaleMode = .aspectFit

        makePoints(shouldScale: !store.polygonCoversScreen)
        shapeNode = makeShapeNode()
    }
    
    func makePoints(shouldScale: Bool = true) {
        let offset = baryanCenter(ofPoints: points)
        self.points = points.offset(by: -offset).scaled(by: shouldScale ? scale : 1)
        self.edges = makeEdgesConnectingDots(ofPoints: points)
    }
    
    //FIXME: Unrecusrify to reduce function calls
    func drawSubdivision(triangle: Triangle, num: Int = 0, alpha: Double = 1, path: CGMutablePath, progressHandler: ((Double) -> Void)? = nil) {
        let triangles = subdivide(triangle: triangle)
        let numTris = Double(triangles.count)
        triangles.enumerated().forEach { (i, triangle) in
            let i = Double(i)
            let currentProgress = (i) / numTris
            let delta = 1 / numTris
            draw(edges: triangle.edges, alpha: alpha, toPath: path)
            if num > 0 {
                drawSubdivision(triangle: triangle, num: num - 1, alpha: alpha * 0.65, path: path) { progress in
                    progressHandler?(currentProgress + progress * delta)
                }
            } else {
                progressHandler?((i+1) / numTris)
            }
        }
    }
    
    func subdivide(triangle: Triangle) -> [Triangle] {
        let center = baryanCenter(ofPoints: triangle.points)
        let edges = triangle.edges
        var triangles = [Triangle]()
        edges.forEach { edge in
            let mid = edge.point(at: subdivideTime)
            let tri1Points = [edge.p1, center, mid]
            let tri2Points = [edge.p2, center, mid]
            
            triangles += [
                Triangle(points: tri1Points, edges: makeEdgesConnectingDots(ofPoints: tri1Points)),
                Triangle(points: tri2Points, edges: makeEdgesConnectingDots(ofPoints: tri2Points)),
            ]
        }
        return triangles
    }
    
    func draw(points: [DPoint]) {
        let pointsPath = CGMutablePath()

        for point in points {
            let rect = CGRect(x: point.x, y: point.y, width: pointRadius, height: pointRadius)
            pointsPath.addEllipse(in: rect)
        }

        let pointNode = SKShapeNode(path: pointsPath)
        pointNode.fillColor = foreground
        self.addChild(pointNode)
    }
    
    private func makeOrGetShapeNode() -> SKShapeNode {
        if shapeNodeIndex < shapeNodes.count {
            let shapeNode = shapeNodes[shapeNodeIndex]
            shapeNodeIndex += 1
            return shapeNode
        }

        let shapeNode = makeShapeNode()
        self.shapeNodes.append(shapeNode)
        return shapeNode
    }
    
    private func makeShapeNode() -> SKShapeNode {
        let shapeNode = SKShapeNode()
        shapeNode.lineWidth = pointRadius
        shapeNode.isAntialiased = true
        shapeNode.strokeColor = foreground
        self.addChild(shapeNode)
        
        return shapeNode
    }
    
    func draw(edges: [Edge], alpha: Double = 1, toPath path: CGMutablePath) {
        edges.forEach { $0.draw(toPath: path) }
    }
    
    func makeEdgesConnectingDots(ofPoints points: [DPoint]) -> [Edge] {
        points.indices.map { i in
            let p1 = points[i + 0]
            let p2 = points[(i + 1) % points.count]
            
            return Edge(p1: p1, p2: p2)
        }
    }
    
    func baryanCenter(ofPoints points: [DPoint]) -> DPoint {
        var result = DPoint.zero
        
        for point in points {
            result += point
        }
        
        let scale = 1 / Double(points.count)
        return scale * result
    }
    
    func makeEdgesConnectingDots(ofPoints points: [DPoint], toCenter center: DPoint) -> [Edge] {
        points.map { point in
            Edge(p1: point, p2: center)
        }
    }
    
    var rotationAngle: CGFloat = 0
    
    func animateOneFrame(currentTime: TimeInterval) {
        if Int(floor(currentTime / (Double.pi))) % 2 == 1 {
            subdivideTime = 0.5 * cos(currentTime) + 0.5
        } else {
            subdivideTime = 0.5 * sin(currentTime - .pi / 2) + 0.5
        }
        
        let path = CGMutablePath()
        
        shapeNodeIndex = 0
        
        if rotates {
            self.points = points.map { point in
                let angle = 0.001
                let rotation = simd_double2x2(rows: [SIMD2(x: cos(angle), y: sin(angle)),
                                                     SIMD2(x: -sin(angle), y: cos(angle))])
                return rotation * point
            }
        }
        
        makePoints(shouldScale: false)
        
        let triangle = Triangle(points: points, edges: edges)
        drawSubdivision(triangle: triangle, num: recursionLevel, path: path)
        shapeNode?.path = path
    }
    
}
