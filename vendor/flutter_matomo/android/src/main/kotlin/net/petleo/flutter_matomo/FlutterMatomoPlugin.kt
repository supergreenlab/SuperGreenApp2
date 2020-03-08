package net.petleo.flutter_matomo

import android.app.Activity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import org.matomo.sdk.Matomo
import org.matomo.sdk.Tracker
import org.matomo.sdk.TrackerBuilder
import org.matomo.sdk.extra.TrackHelper

class FlutterMatomoPlugin(val activity: Activity, val channel: MethodChannel) : MethodCallHandler {

    companion object {
        var tracker: Tracker? = null

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter_matomo")
            channel.setMethodCallHandler(FlutterMatomoPlugin(registrar.activity(), channel))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initializeTracker" -> {
                val url = call.argument<String>("url")
                val siteId = call.argument<Int>("siteId")
                try {
                    val matomo: Matomo = Matomo.getInstance(activity.applicationContext)
                    if (tracker == null) {
                        tracker = TrackerBuilder.createDefault(url, siteId ?: 1).build(matomo)
                    }
                    result.success("Matomo:: $url initialized successfully.")
                } catch (e: Exception) {
                    result.success("Matomo:: $url failed with this error: ${e.printStackTrace()}")
                }
            }
            "trackEvent" -> {
                try {
                    val widgetName = call.argument<String>("widgetName")
                    val eventName = call.argument<String>("eventName")
                    val eventAction = call.argument<String>("eventAction") ?: ""

                    TrackHelper.track().event(eventName, eventAction).path(widgetName).with(tracker)

                    result.success("Matomo:: Event $eventName with action $eventAction in $widgetName sent to ${tracker?.apiUrl}")
                } catch (e: Exception) {
                    result.success("Matomo:: Failed to track event, did you call initializeTracker ?")
                }
            }
            "trackScreen" -> {
                try {
                    val widgetName = call.argument<String>("widgetName")
                    TrackHelper.track().screen(widgetName).with(tracker)
                    result.success("Matomo:: Screen $widgetName sent to ${tracker?.apiUrl}")
                } catch (e: Exception) {
                    result.success("Matomo:: Failed to track event, did you call initializeTracker ?")
                }
            }
            "trackDownload" -> {
                try {
                    TrackHelper.track().download().with(tracker)
                    result.success("Matomo:: Download sent to ${tracker?.apiUrl}")
                } catch (e: Exception) {
                    result.success("Matomo:: Failed to track event, did you call initializeTracker ?")
                }
            }
            "trackGoal" -> {
                try {
                    val goalId = call.argument<Int>("goalId")
                    TrackHelper.track().goal(goalId as Int).with(tracker)
                    result.success("Matomo:: Goal $goalId sent to ${tracker?.apiUrl}")
                } catch (e: Exception) {
                    result.success("Matomo:: Failed to track event, did you call initializeTracker ?")
                }
            }
            "dispatchEvents" -> {
                try {
                    tracker?.dispatch()
                    result.success("Matomo:: Events dispatched to ${tracker?.apiUrl}")
                } catch (e: Exception) {
                    result.success("Matomo:: Failed to dispatch events, did you call initializeTracker ?")
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}
