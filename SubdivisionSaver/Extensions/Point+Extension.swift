//
//  Point+Extension.swift
//  Barymetric Subdivision
//
//  Created by Eskil Sviggum on 18/02/2023.
//

import Foundation

extension DPoint {
    func cgPoint() -> CGPoint {
        CGPoint(x: self.x, y: self.y)
    }
}
