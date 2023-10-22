package cn.rootvip.famd

import android.content.Intent
import android.net.Uri
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File


class MainActivity: FlutterActivity() {

    private val CHANNEL = "cn.rootvip.flutter_native_channel/native_methods"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if(call.method == "nativeLibraryDir"){
                result.success(applicationInfo.nativeLibraryDir)
            }else if(call.method == "decryptTS"){
                try {
                    val path: String? = call.argument("path")
                    val key: String? = call.argument("key")
                    val aes = Aes()
                    val file = File(path)
                    val tsbytes = file.readBytes()
                    val decryptbytes = aes.decrypt(tsbytes, key?.toByteArray() ?: null)
                    result.success(decryptbytes?:intArrayOf())
                }catch (e:Exception){
                    result.success(intArrayOf())
                }
            }else if(call.method == "playerVideo"){
                val path: String? = call.argument("path")
                val intent = Intent()
                intent.action = Intent.ACTION_VIEW
                try {
                    val uri = Uri.parse(path)
                    intent.setDataAndType(uri, "video/*")
                    startActivity(intent)
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }  else {
                result.notImplemented()
            }
        }
    }

}
