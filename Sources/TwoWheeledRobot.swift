//
//  TwoWheeledRobot.swift
//  DifferentialRobotCanvas
//
//  Created by Rene Hexel on 18/9/16.
//
//
import Foundation

/// An angle in radians
typealias RadianAngle = Double

/// A length unit (e.g. pixels)
typealias Length = Double

/// Linear velocity in Length units per second
typealias Velocity = Double

/// Rotational velocity in radians per second
typealias RotationalVelocity = Double

/// A simple differential robot.
/// Interpretation of length units is up to the program, but imporantly
/// all position and length variables have to be of the same unit in order for
/// motions and other calculations to make sense.
struct TwoWheeledRobot {
    let wheel: Length                       ///< wheel radius
    let axle: Length                        ///< half-axle (radius) length
    var position: Coordinate2D              ///< current position
    var orientation: RadianAngle            ///< current orientation angle
    var leftVelocity: RotationalVelocity    ///< left wheel rotational velocity
    var rightVelocity: RotationalVelocity   ///< right wheel rotational velocity
}

/// Extension to convert between degrees and radians
extension RadianAngle {
    /// Angle in whole degrees
    var degrees: Int {
        get { return Int(self * 180 / π) }
        set { self = Double(newValue) * π / 180.0 }
    }
}

/// Extension for converting between different units of rotational velocity
extension RotationalVelocity {
    /// initialise from revolutions per second
    init(rps: Double) { self = rps * twoPi }
    /// initialise from revolutions per minute
    init(rpm: Double) { self.init(rps: rpm / 60) }
    /// revolutions per minute
    var rpm: Double {
        get { return rps * 60 }
        set { rps = newValue / 60 }
    }
    /// revolutions per second
    var rps: Double {
        get { return self / twoPi }
        set { self = newValue * twoPi }
    }
}

/// Convert rotational velocity into linear velocity
///
/// - parameter r: wheel radius
/// - parameter ω: rotational velocity in radians per second
///
/// - returns: linear (ground speed) velocity
func groundSpeed(r: Length, ω: RotationalVelocity) -> Velocity { return r * ω }

/// Convert linear velocity (ground speed) to wheel rotational velocity
///
/// - parameter r: wheel radius
/// - parameter v: linear ground speed
///
/// - returns: rotational velocity in radians per second
func rotationalVelocity(r: Length, v: Velocity) -> RotationalVelocity { return v / r }


/// Extension for converting wheel speed to ground speed and vice versa
extension TwoWheeledRobot {
    /// Ground speed of the left wheel
    var groundSpeedLeft: Velocity {
        get { return groundSpeed(r: wheel, ω: leftVelocity) }
        set { leftVelocity = rotationalVelocity(r: wheel, v: newValue) }
    }
    /// Ground speed of the right wheel
    var groundSpeedRight: Velocity {
        get { return groundSpeed(r: wheel, ω: rightVelocity) }
        set { rightVelocity = rotationalVelocity(r: wheel, v: newValue) }
    }
}

/// Clamp the given value between 0..<module by performing
/// a modulo operation
///
/// - parameter value:  original (denormalised) value
/// - parameter modulo: clamp value
///
/// - returns: value % modulo
func modnorm(_ value: Double, modulo: Double = twoPi) -> Double {
    var v = value
    while v >= modulo { v -= modulo }
    while v < 0 { v += modulo }
    return v
}

/// Calculate movements
extension TwoWheeledRobot {
    /// return how much the robot has shifted in a tiven time
    func delta(_ timeUnits: Double = 1.0) -> (position: Coordinate2D, θ: RadianAngle) {
        let leftDistance = groundSpeedLeft * timeUnits
        let rightDistance = groundSpeedRight * timeUnits
        let deltaDistance = (leftDistance + rightDistance) / 2
        let dθ = (leftDistance - rightDistance) / axle
        let θ = modnorm(orientation + dθ)
        let dx = deltaDistance * cos(θ)
        let dy = deltaDistance * sin(θ)
        return (Coordinate2D(x: position.x + dx, y: position.y + dy), θ)
    }
    /// Mutating move that shifts the position of the receiver
    mutating func move(_ timeUnits: Double = 1.0) {
        (position, orientation) = delta(timeUnits)
    }
    /// Nonmutating move that returns a new robot with its position shifted
    func moved(_ timeUnits: Double = 1.0) -> TwoWheeledRobot {
        let (p, θ) = delta(timeUnits)
        return TwoWheeledRobot(wheel: wheel, axle: axle, position: p, orientation: θ, leftVelocity: leftVelocity, rightVelocity: rightVelocity)
    }
}
