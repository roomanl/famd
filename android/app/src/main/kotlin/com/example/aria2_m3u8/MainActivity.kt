package com.example.aria2_m3u8

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File


class MainActivity: FlutterActivity() {

    private val CHANNEL = "cn.rootvip.flutter_native_channel/native_methods"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getAria2SoPath") {
                val fileAria2c = File(getApplicationInfo().nativeLibraryDir, "libaria2c.so")
                val version = fileAria2c.getAbsolutePath()
                result.success(version)
            } else {
                result.notImplemented()
            }
        }
    }

}
