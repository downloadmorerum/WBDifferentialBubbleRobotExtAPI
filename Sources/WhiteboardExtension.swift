//
//  WhiteboardExtension.swift
//  DifferentialRobotCanvas
//
//  Created by Rene Hexel on 20/9/16.
//
//
import CGUSimpleWhiteboard

/// two wheeled robot extension to convert to/from whiteboard messages
extension TwoWheeledRobot {
    /// Whiteboard representation of robot.
    /// This models a simple robot where the pixels/s speed is considered
    /// equivalent to mm/s for the whiteboard.  Acceleration is instant,
    /// and there is no odometry encoder.
    var whiteboardData: wb_differential_robot {
        get {
            let l = Int16(groundSpeedLeft)
            let r = Int16(groundSpeedRight)
            let leftMotor  = wb_kinematic_motor(speed: l, accel: 0, odo: 0, motorOn: l != 0, encoderOn: false)
            let rightMotor = wb_kinematic_motor(speed: r, accel: 0, odo: 0, motorOn: r != 0, encoderOn: false)
            let wbmsg = wb_differential_robot(left_motor: leftMotor, right_motor: rightMotor)
            return wbmsg
        }
        set {
            groundSpeedLeft  = Velocity(newValue.left_motor.speed)
            groundSpeedRight = Velocity(newValue.right_motor.speed)
        }
    }
}

/// whiteboard extension for differential robot control/status messages
extension Whiteboard {
    /// Differential robot control message
    var differentialRobotControl: wb_differential_robot {
        get { return get(kDifferentialRobotControl_v) }
        set { post(newValue, kDifferentialRobotControl_v) }
    }
    /// Differential robot status message
    var differentialRobotStatus: wb_differential_robot {
        get { return get(kDifferentialRobotStatus_v) }
        set { post(newValue, kDifferentialRobotStatus_v) }
    }
}

