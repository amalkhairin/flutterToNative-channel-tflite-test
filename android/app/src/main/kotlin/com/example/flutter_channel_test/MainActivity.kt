package com.example.flutter_channel_test

import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.provider.MediaStore
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private val CHANNEL: String = "com.channel.test"
    private var tfLiteClassifier: TFLiteClassifier = TFLiteClassifier(this@MainActivity)

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        tfLiteClassifier
                .initialize()
                .addOnSuccessListener {  }
                .addOnFailureListener { e -> Log.e("test", "Error in setting up the classifier.", e) }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .setMethodCallHandler { call, result ->
                    when(call.method){
                        "coba" -> result.success("success")
                        "tflite" -> {
                            var bitmap = call.arguments;
                            tfLiteClassifier
                                    .classifyAsync(bitmap)
                                    .addOnSuccessListener { resultText -> result.success(result) }
                                    .addOnFailureListener { e -> Log.e("test", "Error in setting up the classifier.", e) }
                        }
                    }
                }
    }

    fun imgClassify(bitmap: Bitmap){

    }

}
