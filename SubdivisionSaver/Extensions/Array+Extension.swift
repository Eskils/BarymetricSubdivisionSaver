//
//  Array+Extension.swift
//  Barymetric Subdivision
//
//  Created by Eskil Sviggum on 18/02/2023.
//

import Foundation
import simd

extension Array where Element == DPoint {
    static func triangle() -> Self {
        [
            DPoint(x: 0, y: 0),
            DPoint(x: 1, y: 0),
            DPoint(x: 0.5, y: sqrt(3)/2),
        ]
    }
    
    static func square() -> Self {
        [
            DPoint(x: 0, y: 0),
            DPoint(x: 1, y: 0),
            DPoint(x: 1, y: 1),
            DPoint(x: 0, y: 1),
        ]
    }
    
    static func pentagon() -> Self {
        return Self.regularPolygon(n: 5)
    }
    
    static func hexagon() -> Self {
        return Self.regularPolygon(n: 6)
    }
    
    static func heptagon() -> Self {
        return Self.regularPolygon(n: 7)
    }
    
    static func regularPolygon(n vertices: Double, max: Int? = nil) -> Self {
        let max = max ?? Int(ceil(vertices))
        let theta = 2 * Double.pi / vertices
        let h: Double = 1 / (2 * tan(theta / 2))
        let scale = 1 / h
        let initial = DPoint(x: -0.5, y: -h)
        var points = [DPoint]()
        
        for i in 0..<max {
            let angle = Swift.min(2 * Double.pi, Double(i) * theta)
            let rotation = simd_double2x2(rows: [SIMD2(x: cos(angle), y: sin(angle)),
                                                 SIMD2(x: -sin(angle), y: cos(angle))])
            let point = scale * rotation * initial
            points.append(point)
        }
        
        return points
    }
    
    func scaled(by factor: Double) -> Self {
        self.map { point in
            factor * point
        }
    }
    
    func offset(by offset: Double) -> Self {
        self.map { point in
            offset + point
        }
    }
    
    func offset(by offset: DPoint) -> Self {
        self.map { point in
            offset + point
        }
    }
}
