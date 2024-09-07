package cn.rootvip.famd

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.Settings;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import cn.rootvip.famd.util.AESUtil


class MainActivity: FlutterActivity() {

    private val CHANNEL = "cn.rootvip.flutter_native_channel/native_methods"
    private var channelResult: MethodChannel.Result? =null;
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            channelResult=result;
            if(call.method == "nativeLibraryDir"){
                result.success(applicationInfo.nativeLibraryDir)
            }else if(call.method == "decryptTS"){
                try {
                    val path: String? = call.argument("path")
                    var key = call.argument<ByteArray>("key")
                    var iv = call.argument<ByteArray>("iv")
//                    val key: String? = call.argument("key")
//                    val iv: String? = call.argument("iv")
                    val file = File(path)
                    val tsbytes = file.readBytes()
                    val decryptbytes = AESUtil.decrypt(tsbytes, key?: null, iv?: null)
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
            } else if(call.method == "requestPermission"){
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) { //30
                    // 先判断有没有权限
                    if (!Environment.isExternalStorageManager()) {
                        //跳转到设置界面引导用户打开
                        val intent = Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION)
                        intent.data = Uri.parse("package:$packageName")
                        startActivityForResult(intent, 6666)
                    }else{
                        result.success(true)
                    }
                }

            } else {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode==6666){
            if (Environment.isExternalStorageManager()){
                channelResult?.success(true)
            } else {
                channelResult?.success(false);
            }
        }
    }


}
