#if os(Linux)
    import Glibc
#else
    import Darwin
#endif
import CGUSimpleWhiteboard
import CExtAPI

/// Show program usage
func usage() -> Never  {
    fputs("Usage: \(CommandLine.arguments[0]) [-h hostIP] port leftMotor rightMotor sensor\n", stderr)
    exit(EXIT_FAILURE)
}

var wb = Whiteboard()
var differentialRobot = TwoWheeledRobot(wheel: 7, axle: 10, position: Coordinate2D(x: 0, y: 0), orientation: 0, leftVelocity: 0, rightVelocity: 0)
var host = "127.0.0.1"

while let (opt, param) = get_opt("h:") {
    switch opt {
    case "h":
        guard let h = param else { usage() }
        host = h
    case "?": fallthrough
    default:
        usage()
    }
}

guard CommandLine.argc > optind + 3 else { usage() }
let i = Int(optind)
guard let port       = CInt(CommandLine.arguments[i])   else { usage() }
guard let leftMotor  = CInt(CommandLine.arguments[i+1]) else { usage() }
guard let rightMotor = CInt(CommandLine.arguments[i+2]) else { usage() }
guard let sensor     = CInt(CommandLine.arguments[i+3]) else { usage() }
//
// Start and run the simulation
//
let clientID = simxStart(host, port, 1, 1, 2000, 5)
guard clientID != -1 else { fatalError("Could not connect to \(host):\(port)") }

while simxGetConnectionId(clientID) != -1 {
    extApi_sleepMs(5)
    var sensorTrigger = simxUChar(0)
    guard simxReadProximitySensor(clientID, sensor, &sensorTrigger, nil, nil, nil, simxInt(simx_opmode_streaming)) == simxInt(simx_return_ok) else { continue }
    //
    // get the control message from the whiteboard and set robot velocity
    //
    differentialRobot.whiteboardData = wb.differentialRobotControl
    if sensorTrigger == 1 &&
        differentialRobot.leftVelocity  > 0 &&
        differentialRobot.rightVelocity > 0 {
        differentialRobot.leftVelocity  = 0
        differentialRobot.rightVelocity = 0
    }
    simxSetJointTargetVelocity(clientID, leftMotor, simxFloat(differentialRobot.leftVelocity), simxInt(simx_opmode_oneshot))
    simxSetJointTargetVelocity(clientID, rightMotor,simxFloat(differentialRobot.rightVelocity),simxInt(simx_opmode_oneshot))
    //
    // post the current wheel speed as a status message
    //
    var lLinear  = simxFloat(0), rLinear  = simxFloat(0)
    var lAngular = simxFloat(0), rAngular = simxFloat(0)
    simxGetObjectVelocity(clientID, leftMotor,  &lLinear, &lAngular, simxInt(simx_opmode_oneshot))
    simxGetObjectVelocity(clientID, rightMotor, &rLinear, &rAngular, simxInt(simx_opmode_oneshot))
    differentialRobot.leftVelocity  = Double(lAngular)
    differentialRobot.rightVelocity = Double(rAngular)
    wb.differentialRobotStatus = differentialRobot.whiteboardData
}

simxFinish(clientID)
