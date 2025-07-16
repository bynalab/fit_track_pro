package com.example.fit_track_pro

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val EVENT_CHANNEL = "com.fittrack/workoutStream"
    private val METHOD_CHANNEL = "workout_channel"

    // Ideally use a singleton or bound service instead
    private var workoutService = WorkoutService()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Set up EventChannel
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(workoutService)

        // Set up MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "workout_channel")
    .setMethodCallHandler { call, result ->
        when (call.method) {
            "resetStats" -> {
                workoutService.resetStats()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }
    }
}