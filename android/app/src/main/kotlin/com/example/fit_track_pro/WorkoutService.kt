// package com.example.fittrack_pro

// import android.app.*
// import android.content.Intent
// import android.os.IBinder
// import android.os.Build
// import android.os.Handler
// import android.os.Looper
// import androidx.core.app.NotificationCompat

// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel

// lateinit var methodChannel: MethodChannel

// fun setFlutterEngine(engine: FlutterEngine) {
//     methodChannel = MethodChannel(engine.dartExecutor.binaryMessenger, "fittrack_pro/workout")
// }

// class WorkoutService : Service() {

//     private val channelId = "workout_channel"
//     private val notificationId = 1
//     private val handler = Handler(Looper.getMainLooper())
//     private var elapsed = 0

//     override fun onCreate() {
//         super.onCreate()
//         createNotificationChannel()
//         startForeground(notificationId, buildNotification())
//         simulateWorkoutProgress()
//     }

//     private fun simulateWorkoutProgress() {
//         handler.postDelayed(object : Runnable {
//             override fun run() {
//                 elapsed += 1

//                 // Send updates to Flutter via MethodChannel
//                 methodChannel.invokeMethod("getWorkoutStats", mapOf(
//                     "steps" to elapsed * 20,
//                     "calories" to elapsed * 2,
//                     "bpm" to (75 + (elapsed % 10))
//                 ))

//                 updateNotification()
//                 handler.postDelayed(this, 1000)
//             }
//         }, 1000)
//     }

//     private fun updateNotification() {
//         val notification = buildNotification("Workout in progress: $elapsed sec")
//         val nm = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
//         nm.notify(notificationId, notification)
//     }

//     private fun buildNotification(content: String = "Tracking workout..."): Notification {
//         val intent = Intent(this, MainActivity::class.java)
//         val pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_IMMUTABLE)

//         return NotificationCompat.Builder(this, channelId)
//             .setContentTitle("FitTrack Pro")
//             .setContentText(content)
//             .setSmallIcon(R.drawable.ic_launcher)
//             .setContentIntent(pendingIntent)
//             .setOngoing(true)
//             .build()
//     }

//     private fun createNotificationChannel() {
//         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//             val serviceChannel = NotificationChannel(
//                 channelId,
//                 "Workout Tracking",
//                 NotificationManager.IMPORTANCE_LOW
//             )
//             val manager = getSystemService(NotificationManager::class.java)
//             manager.createNotificationChannel(serviceChannel)
//         }
//     }

//     override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
//         return START_STICKY
//     }

//     override fun onBind(intent: Intent?): IBinder? = null
// }

package com.fittrack

import android.app.Service
import android.content.Intent
import android.os.IBinder
import io.flutter.plugin.common.EventChannel
import java.util.*
import kotlin.concurrent.timerTask

class WorkoutService : Service(), EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null
    private var timer: Timer? = null
    private var elapsed = 0

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        // You can optionally set up other services here
    }

    fun startStreamingStats() {
        timer = Timer()
        timer?.scheduleAtFixedRate(timerTask {
            elapsed += 1
            val stats = mapOf(
                "steps" to elapsed * 15,
                "calories" to elapsed * 2,
                "bpm" to 70 + (elapsed % 10)
            )
            eventSink?.success(stats)
        }, 0, 1000)
    }

    fun stopStreamingStats() {
        timer?.cancel()
        timer = null
        eventSink = null
    }

    // EventChannel.StreamHandler methods
    override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
        eventSink = sink
        startStreamingStats()
    }

    override fun onCancel(arguments: Any?) {
        stopStreamingStats()
    }
}