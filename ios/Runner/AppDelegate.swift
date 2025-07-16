import UIKit
import Flutter

import flutter_local_notifications


@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
       FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
         GeneratedPluginRegistrant.register(with: registry)
       }

       if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
       }

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
