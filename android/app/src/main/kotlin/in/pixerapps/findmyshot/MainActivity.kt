package `in`.pixerapps.findmyshot

import android.content.Intent
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private lateinit var forService : Intent
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        GeneratedPluginRegistrant.registerWith(this)

        forService = Intent(this,MyService::class.java)

        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, "in.pixerapps.findmyshot").setMethodCallHandler {
            call, result ->
            if (call.method.equals("startService")){
                startService()
                result.success("Service Started")
            }
        }

    }

    override fun onDestroy() {
        super.onDestroy()
        stopService(forService)
    }
    private fun startService(){
        if (Build.VERSION.SDK_INT>= Build.VERSION_CODES.O){
            startForegroundService(forService)
        }else{
            startService(forService)
        }
    }
}
