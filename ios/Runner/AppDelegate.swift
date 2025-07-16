//import UIKit
//import Flutter
//
//@main
//@objc class AppDelegate: FlutterAppDelegate {
//    let manager = WorkoutManager()
//
//    override func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//    ) -> Bool {
//        GeneratedPluginRegistrant.register(with: self)
//        
//        if let controller = window?.rootViewController as? FlutterViewController {
//            manager.channel = FlutterMethodChannel(name: "fittrack_pro/workout", binaryMessenger: controller.binaryMessenger)
//            manager.startWorkout()
//        }
//        
//        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//    }
//}


import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController

        let eventChannel = FlutterEventChannel(
            name: "com.fittrack/workoutStream",
            binaryMessenger: controller.binaryMessenger
        )

        let workoutManager = WorkoutManager()
        eventChannel.setStreamHandler(workoutManager)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
