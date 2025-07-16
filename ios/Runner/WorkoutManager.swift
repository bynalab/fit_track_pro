//import Foundation
//import Flutter
//
//class WorkoutManager {
//    var channel: FlutterMethodChannel?
//    var timer: Timer?
//    var elapsed = 0
//
//    func startWorkout() {
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//            self.elapsed += 1
//            self.sendStats()
//        }
//    }
//
//    func sendStats() {
//        let stats: [String: Any] = [
//            "steps": elapsed * 15,
//            "calories": elapsed * 2,
//            "bpm": 70 + (elapsed % 10)
//        ]
//        channel?.invokeMethod("getWorkoutStats", arguments: stats)
//    }
//}


import Foundation
import Flutter

class WorkoutManager: NSObject, FlutterStreamHandler {
    var eventSink: FlutterEventSink?
    var timer: Timer?
    var elapsed = 0

    func startWorkout() {
        // Start a timer that emits data every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsed += 1
            self.sendStats()
        }
    }

    func stopWorkout() {
        timer?.invalidate()
        timer = nil
    }

    func sendStats() {
        let stats: [String: Any] = [
            "steps": elapsed * 15,
            "calories": elapsed * 2,
            "bpm": 70 + (elapsed % 10)
        ]
        eventSink?(stats)
    }

    // MARK: - FlutterStreamHandler methods

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        startWorkout()
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        stopWorkout()
        self.eventSink = nil
        return nil
    }
}
