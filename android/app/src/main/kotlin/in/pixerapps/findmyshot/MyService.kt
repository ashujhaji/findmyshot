package `in`.pixerapps.findmyshot

import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class MyService : Service() {

    override fun onCreate() {
        super.onCreate()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val builder = NotificationCompat.Builder(this, "messages")
                    .setContentText("App is running in background")
                    .setContentTitle("Find My Shot")
                    .setSmallIcon(R.drawable.launch_background)

            startForeground(101, builder.build())
        }
    }


    override fun onBind(p0: Intent?): IBinder? {
        return null
    }
}