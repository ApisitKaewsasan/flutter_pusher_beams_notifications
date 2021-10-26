package com.dotscoket.pusherbeamsnotifications.pusherBeamsNotificationsExample.pusher_beams_notifications

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.google.firebase.messaging.RemoteMessage
import com.google.gson.Gson
import com.pusher.pushnotifications.PushNotificationReceivedListener
import com.pusher.pushnotifications.PushNotifications
import com.pusher.pushnotifications.PushNotificationsInstance

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** PusherBeamsNotificationsPlugin */
class PusherBeamsNotificationsPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  companion object {
    private var eventSink: EventChannel.EventSink? = null
    var TAG = "PusherBeamsNotificationsPlugin"
  }

  private lateinit var channel: MethodChannel

  private lateinit var context: Context
  private lateinit var activity: Activity

  private var instance: PushNotificationsInstance? = null
  private var instanceId: String? = null


  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "pusher_beams_notifications")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext

    val eventStream =
      EventChannel(flutterPluginBinding.binaryMessenger, "pusher_beams_message_remote")


    eventStream.setStreamHandler(object : EventChannel.StreamHandler {
      override fun onListen(args: Any, eventSink: EventChannel.EventSink) {
        PusherBeamsNotificationsPlugin.eventSink = eventSink
      }

      override fun onCancel(args: Any) {
        Log.d(TAG, String.format("onCancel args: %s", args.toString()))
      }
    })
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

    if (call.method != "start" && instance == null) {
      return result.error(null, "You should must call .start() before anything", null)
    }

    when (call.method) {
      "start" -> this.start(result, call.arguments<String>())
      "stop" -> this.stop(result)
      "setOnMessageReceivedListener" -> this.setOnMessageReceivedListener(result)
      "addDeviceInterest" -> this.addDeviceInterest(result, call.arguments<String>())
      "removeDeviceInterest" -> this.removeDeviceInterest(result, call.arguments<String>())
      "getDeviceInterests" -> this.getDeviceInterests(result)
      "setDeviceInterests" -> this.setDeviceInterests(result, call.arguments<List<String>>())
      "clearDeviceInterests" -> this.clearDeviceInterests(result)
      "clearAllState" -> this.clearAllState(result)
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun setOnMessageReceivedListener(result: Result) {
    try {
      PushNotifications.setOnMessageReceivedListenerForVisibleActivity(activity, object :
        PushNotificationReceivedListener {
        override fun onMessageReceived(remoteMessage: RemoteMessage) {
          val gson = Gson()
          remoteMessage.notification?.apply {
            activity.runOnUiThread {
              eventSink!!.success(
                gson.toJson(
                  this,
                  RemoteMessage.Notification::class.java
                )
              )
            }
          }
        }
      })
      Log.i(this.toString(), "PushNotificationReceivedListener")

      // result.success(null)
    } catch (e: Exception) {
      result.error(null, e.message, null)
    }
  }

  private fun start(result: Result, newInstanceId: String) {
    try {
      if (instance == null) {
        instance = PushNotifications.start(context, newInstanceId)
        instanceId = newInstanceId

      } else if (instanceId != newInstanceId) {
        return result.error(null, "You should use this library as a Singleton", null)
      }

      Log.i(this.toString(), "Start $newInstanceId")

      result.success(null)
    } catch (e: Exception) {
      result.error(null, e.message, null)
    }
  }

  private fun stop(result: Result) {
    try {
      instance?.stop()
      Log.i(this.toString(), "Stop")

      result.success(null)
    } catch (e: Exception) {
      result.error(null, e.message, null)
    }
  }

  private fun addDeviceInterest(result: Result, interest: String) {
    try {
      instance?.addDeviceInterest(interest)
      Log.i(this.toString(), "AddInterest: $interest")

      result.success(null)
    } catch (e: Exception) {
      result.error(null, e.message, null)
    }
  }

  private fun removeDeviceInterest(result: Result, interest: String) {
    try {
      instance?.removeDeviceInterest(interest)
      Log.i(this.toString(), "RemoveInterest: $interest")

      result.success(null)
    } catch (e: Exception) {
      result.error(null, e.message, null)
    }
  }

  private fun getDeviceInterests(result: Result) {
    try {
      val interests = instance?.getDeviceInterests()
      Log.i(this.toString(), "GetInterests: ${interests.toString()}")

      result.success(interests?.toList())
    } catch (e: Exception) {
      result.error(null, e.message, null)
    }
  }

  private fun setDeviceInterests(result: Result, interests: List<String>) {
    try {
      instance?.setDeviceInterests(interests.toSet())
      Log.i(this.toString(), "SetInterests: $interests")

      result.success(interests.toList())
    } catch (e: Exception) {
      result.error(null, e.message, null)
    }
  }

  private fun clearDeviceInterests(result: Result) {
    try {
      instance?.clearDeviceInterests()
      Log.i(this.toString(), "ClearInterests")

      result.success(null)
    } catch (e: Exception) {
      result.error(null, e.message, null)
    }
  }

  private fun clearAllState(result: Result) {
    try {
      instance?.clearAllState()
      Log.i(this.toString(), "ClearAllState")

      result.success(null)
    } catch (e: Exception) {
      result.error(null, e.message, null)
    }
  }

  override fun onDetachedFromActivityForConfigChanges() {

  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

  }

  override fun onDetachedFromActivity() {

  }

}
