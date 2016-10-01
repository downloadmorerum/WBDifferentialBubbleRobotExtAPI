//
//  Coordinate2D.swift
//  DifferentialRobotCanvas
//
//  Created by Rene Hexel on 18/9/16.
//
//
import Foundation

/// A simple, 2-dimensional vector
protocol Vector2D {
    var x: Double { get }
    var y: Double { get }
    init(x: Double, y: Double)
}


/// Pi as a double
let π = Double.pi

/// Two times Pi
let twoPi = 2 * π

/// Half of Pi
let halfPi = M_PI_2


/// polar coordinate helper functions
extension Vector2D {
    /// distance from (0,0)
    var polarDistance: Double { return sqrt(x*x + y*y) }

    /// angle in radians
    var polarAngle: Double {
        guard x != 0 else { return y > 0 ? halfPi : (twoPi - halfPi) }
        let angle = atan(y/x) + x < 0 ? π : 0
        return angle
    }

    /// initialise from polar coordinates
    init(r: Double, θ: Double) { self.init(x: r * cos(θ), y: r * sin(θ)) }
}

/// add two vectors
func +<V: Vector2D>(lhs: V, rhs: V) -> V {
    return V(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

/// subtract two vectors
func -<V: Vector2D>(lhs: V, rhs: V) -> V {
    return V(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

/// A 2-dimensional coordinate implementation
struct Coordinate2D: Vector2D {
    var x: Double
    var y: Double
}
