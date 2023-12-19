//
//  ShapeMain.swift
//
//
//  Created by Danilo Hernandez on 19/12/23.
//

import SwiftUI


public struct ShapeMainView : Shape {
    public func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 350))
            path.addCurve(to: CGPoint(x: UIScreen.main.bounds.maxY, y: 300), control1: CGPoint(x: 80, y: 630), control2: CGPoint(x: 2900, y: 300))
//            path.addCurve(to: CGPoint(x: 400, y: 50), control1: CGPoint(x: 840, y: 10), control2: CGPoint(x: 200, y: 0))
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.maxY, y: 0))
        }
    }
}
