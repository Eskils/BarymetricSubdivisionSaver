//
//  Edge.swift
//  Barymetric Subdivision
//
//  Created by Eskil Sviggum on 18/02/2023.
//

import Foundation
import CoreGraphics

struct Edge {
    let p1: DPoint
    let p2: DPoint
    
    func path() -> CGPath {
        let path = CGMutablePath()
        draw(toPath: path)
        return path
    }
    
    func draw(toPath path: CGMutablePath) {
        path.move(to: p1.cgPoint())
        path.addLine(to: p2.cgPoint())
    }
    
    func midpoint() -> DPoint {
        point(at: 0.5)
    }
    
    func point(at t: Double) -> DPoint {
        p1 + t * (p2 - p1)
    }
}
