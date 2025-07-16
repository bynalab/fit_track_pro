package com.example.fit_track_pro

import android.app.Service
import android.content.Intent
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import io.flutter.plugin.common.EventChannel
import java.util.*

class WorkoutService : Service(), EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null
    private var timer: Timer? = null
    private var elapsed = 0

    override fun onBind(intent: Intent?): IBinder? = null

    fun startStreamingStats() {
        val mainHandler = Handler(Looper.getMainLooper())
        timer = Timer()

        timer?.scheduleAtFixedRate(object : TimerTask() {
            override fun run() {
                val data = mapOf(
                    "steps" to elapsed * 3,
                    "calories" to elapsed * 2,
                    "bpm" to 70 + (elapsed % 10)
                )

                mainHandler.post {
                    eventSink?.success(data)
                }

                elapsed++
            }
        }, 0, 1000)
    }

    fun stopStreamingStats() {
        timer?.cancel()
        timer = null
        eventSink = null
    }

    override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
        eventSink = sink
        startStreamingStats()
    }

    override fun onCancel(arguments: Any?) {
        stopStreamingStats()
    }
}