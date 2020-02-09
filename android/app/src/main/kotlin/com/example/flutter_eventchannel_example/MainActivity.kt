package com.example.flutter_eventchannel_example

import android.os.Handler
//import android.util.Log
import androidx.annotation.NonNull
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    private lateinit var channel: EventChannel
    var eventSink: EventSink? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        channel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.eventchannel/interop")
        channel.setStreamHandler(
                object : StreamHandler {
                    override fun onListen(arguments: Any?, events: EventSink) {
                        eventSink = events
                        Log.d("Android", "EventChannel onListen called")
                        Handler().postDelayed({
                            eventSink?.success("Android")
                            //eventSink?.endOfStream()
                            //eventSink?.error("error code", "error message","error details")
                        }, 500)
                    }
                    override fun onCancel(arguments: Any?) {
                        Log.w("Android", "EventChannel onCancel called")
                    }
                })
    }
}
