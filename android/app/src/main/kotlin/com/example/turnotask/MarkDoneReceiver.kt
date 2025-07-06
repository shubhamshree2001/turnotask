package com.example.turnotask

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import android.app.NotificationManager
import android.content.SharedPreferences
class MarkDoneReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val id = intent.getIntExtra("id", -1)
        Log.d("MarkDoneReceiver", "Mark as done tapped for ID: $id")

        if (id != -1) {
            // Save the ID in SharedPreferences
            val prefs: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            prefs.edit().putInt("flutter.notificationTaskID", id).commit()

            Log.d("MarkDoneReceiver", "Stored notificationTaskId = $id")

            //  Restart the app or bring it to foreground
            val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            launchIntent?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            launchIntent?.putExtra("action", "markDoneTapped")
            launchIntent?.putExtra("taskId", id)
            context.startActivity(launchIntent)

            // Cancel the notification
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as android.app.NotificationManager
            notificationManager.cancel(id)
        }
    }
}