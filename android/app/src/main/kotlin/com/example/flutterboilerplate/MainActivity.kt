package com.example.flutterboilerplate

import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val METHOD_CHANNEL = "com.example.flutterboilerplate/share"
        private const val METHOD_CHANNEL_READY = "methodChannelReady"
        private const val HANDLE_SHARED_LINK = "handleSharedLink"
    }

    private lateinit var methodChannel: MethodChannel

    private var tempUrl: String? = null
    private var isMethodChannelReady = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        configureMethodChannel(flutterEngine)
    }

    private fun configureMethodChannel(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
        methodChannel.setMethodCallHandler(::handleMethodCall)
    }

    private fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == METHOD_CHANNEL_READY) {
            Log.d("MainActivity", "Method channel is ready")
            isMethodChannelReady = true
            if (tempUrl != null) {
                sendUrlToFlutter(tempUrl!!)
                tempUrl = null
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {
        Log.d("MainActivity", "Handling intent: $intent")
        if (intent.action != Intent.ACTION_SEND) {
            Log.d("MainActivity", "Skipping because it's not a link-sharing intent")
            return
        }
        val url = intent.getStringExtra(Intent.EXTRA_TEXT) ?: ""
        if (isMethodChannelReady) {
            sendUrlToFlutter(url)
        } else {
            Log.d("MainActivity", "Method channel is not ready. Saving url for later")
            tempUrl = url
        }
    }

    private fun sendUrlToFlutter(url: String) {
        Log.d("MainActivity", "Sending url to flutter: $url")
        methodChannel.invokeMethod(HANDLE_SHARED_LINK, url)
    }


}
