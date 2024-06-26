package com.example.maridian
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import com.google.firebase.database.annotations.NotNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import io.flutter.embedding.android.FlutterActivity

// Note that if we do changes to the Android documents or other OS specific documents we need to rebuild the code
// Hot reloading might not work because it just reload from the flutter side
// Not with the Android native side
class MainActivity: FlutterActivity() {

  // We need to listen from the same method channel here.
  // Flutter engine runs on top of android.
  private val CHANNEL = "com.januda.flutter/battery"

  // We need to configure the channel we are calling
  override fun configureFlutterEngine(@NotNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    // Registering the method channel
    // It is recommended to only have a one channel to a project
    // You can communicate using multiple method through this single channel
    MethodChannel(
      flutterEngine.dartExecutor.binaryMessenger,
      CHANNEL
    ).setMethodCallHandler { call, result ->
      // This method is invoked on the main thread.
      // Doing the mapping here
      
      if (call.method == "getBatteryLevel") {
        // If the batteryLevel > -1 ----> Indicates that there is a value coming ( starts from 0 )
        val batteryLevel = getBatteryLevel()

        if (batteryLevel != -1) {
          result.success(batteryLevel)
        } else {
          result.error("UNAVAILABLE", "Battery level not available.", null)
        }
      } else {
        result.notImplemented()
      }

    }

  }

  // This is the implementation of the function getBatteryLevel() for android in Kotlin
  // Note that the name of the function is same as the function name defined in the flutter file.
  // This is a good practice so we can avoid confusion
  // We can use another name too. Because we are doing the mapping above.
  private fun getBatteryLevel(): Int {
    val batteryLevel: Int
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    } else {
      val intent = ContextWrapper(applicationContext).registerReceiver(
        null,
        IntentFilter(Intent.ACTION_BATTERY_CHANGED)
      )
      batteryLevel =
        intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(
          BatteryManager.EXTRA_SCALE,
          -1
        )
    }

    return batteryLevel
  }
}
