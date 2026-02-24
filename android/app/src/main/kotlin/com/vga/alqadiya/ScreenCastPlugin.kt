package com.vga.alqadiya

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.mediarouter.app.MediaRouteButton
import androidx.mediarouter.media.MediaRouter
import com.google.android.gms.cast.CastDevice
import com.google.android.gms.cast.framework.CastButtonFactory
import com.google.android.gms.cast.framework.CastContext
import com.google.android.gms.cast.framework.CastSession
import com.google.android.gms.cast.framework.SessionManager
import com.google.android.gms.cast.framework.SessionManagerListener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class ScreenCastPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var context: Context? = null
    private var mediaRouter: MediaRouter? = null
    private var castContext: CastContext? = null
    private var sessionManager: SessionManager? = null
    private var castSession: CastSession? = null
    
    private val sessionManagerListener = object : SessionManagerListener<CastSession> {
        override fun onSessionStarted(session: CastSession, sessionId: String) {
            castSession = session
            val device = session.castDevice
            if (device != null) {
                notifyDeviceConnected(device)
            }
        }
        
        override fun onSessionEnded(session: CastSession, error: Int) {
            castSession = null
            notifyDeviceDisconnected()
        }
        
        override fun onSessionResumed(session: CastSession, wasSuspended: Boolean) {
            castSession = session
        }
        
        override fun onSessionSuspended(session: CastSession, reason: Int) {
            // Handle session suspended
        }
        
        override fun onSessionStarting(session: CastSession) {
            // Handle session starting
        }
        
        override fun onSessionStartFailed(session: CastSession, error: Int) {
            notifyCastError("Failed to start cast session")
        }
        
        override fun onSessionEnding(session: CastSession) {
            // Handle session ending
        }
        
        override fun onSessionResuming(session: CastSession, sessionId: String) {
            // Handle session resuming
        }
        
        override fun onSessionResumeFailed(session: CastSession, error: Int) {
            notifyCastError("Failed to resume cast session")
        }
    }
    
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "com.vga.alqadiya/screen_cast")
        channel.setMethodCallHandler(this)
        context = binding.applicationContext
    }
    
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
    
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        initializeCast()
    }
    
    override fun onDetachedFromActivity() {
        sessionManager?.removeSessionManagerListener(sessionManagerListener, CastSession::class.java)
        activity = null
    }
    
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }
    
    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }
    
    private fun initializeCast() {
        try {
            context?.let { ctx ->
                castContext = CastContext.getSharedInstance(ctx)
                sessionManager = castContext?.sessionManager
                sessionManager?.addSessionManagerListener(sessionManagerListener, CastSession::class.java)
                
                activity?.let { act ->
                    mediaRouter = MediaRouter.getInstance(act)
                }
            }
        } catch (e: Exception) {
            // Cast framework not available or not configured
            e.printStackTrace()
        }
    }
    
    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "startScanning" -> {
                startScanning(result)
            }
            "stopScanning" -> {
                stopScanning(result)
            }
            "connectToDevice" -> {
                val deviceId = call.argument<String>("deviceId")
                val deviceName = call.argument<String>("deviceName")
                connectToDevice(deviceId, deviceName, result)
            }
            "disconnect" -> {
                disconnect(result)
            }
            "startMirroring" -> {
                startMirroring(result)
            }
            "stopMirroring" -> {
                stopMirroring(result)
            }
            "showCastPicker" -> {
                showCastPicker(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
    
    private fun startScanning(result: Result) {
        try {
            // Scanning is automatic with Google Cast
            // Just notify that scanning has started
            result.success(true)
            
            // Check for available cast devices
            Handler(Looper.getMainLooper()).postDelayed({
                sessionManager?.let { sm ->
                    val currentSession = sm.currentCastSession
                    if (currentSession != null && currentSession.isConnected) {
                        val device = currentSession.castDevice
                        if (device != null) {
                            notifyDeviceFound(device)
                        }
                    }
                }
            }, 1000)
        } catch (e: Exception) {
            result.error("SCAN_ERROR", e.message, null)
        }
    }
    
    private fun stopScanning(result: Result) {
        // Scanning stops automatically
        result.success(true)
    }
    
    private fun connectToDevice(deviceId: String?, deviceName: String?, result: Result) {
        try {
            // Connection is handled by the Cast framework
            // This method is called after user selects a device
            result.success(true)
        } catch (e: Exception) {
            result.error("CONNECT_ERROR", e.message, null)
        }
    }
    
    private fun disconnect(result: Result) {
        try {
            sessionManager?.endCurrentSession(true)
            result.success(true)
        } catch (e: Exception) {
            result.error("DISCONNECT_ERROR", e.message, null)
        }
    }
    
    private fun startMirroring(result: Result) {
        try {
            // Screen mirroring is handled automatically when connected
            val isConnected = castSession?.isConnected ?: false
            result.success(isConnected)
        } catch (e: Exception) {
            result.error("MIRROR_ERROR", e.message, null)
        }
    }
    
    private fun stopMirroring(result: Result) {
        try {
            // Mirroring stops when session ends
            result.success(true)
        } catch (e: Exception) {
            result.error("STOP_MIRROR_ERROR", e.message, null)
        }
    }
    
    private fun showCastPicker(result: Result) {
        Handler(Looper.getMainLooper()).post {
            try {
                activity?.let { act ->
                    castContext?.let { ctx ->
                        // Show the Cast dialog using the session manager
                        try {
                            // Create a MediaRouteButton and trigger its click
                            val mediaRouteButton = MediaRouteButton(act)
                            CastButtonFactory.setUpMediaRouteButton(act, mediaRouteButton)
                            
                            // Show the dialog
                            mediaRouteButton.showDialog()
                            
                            result.success(true)
                        } catch (e: Exception) {
                            // Fallback: try performClick
                            val mediaRouteButton = MediaRouteButton(act)
                            CastButtonFactory.setUpMediaRouteButton(act, mediaRouteButton)
                            mediaRouteButton.performClick()
                            
                            result.success(true)
                        }
                    } ?: result.error("CAST_NOT_INITIALIZED", "Cast context not initialized", null)
                } ?: result.error("NO_ACTIVITY", "Activity not available", null)
            } catch (e: Exception) {
                result.error("PICKER_ERROR", "Failed to show cast picker: ${e.message}", null)
            }
        }
    }
    
    private fun notifyDeviceFound(device: CastDevice) {
        val deviceMap = mapOf(
            "id" to device.deviceId,
            "name" to device.friendlyName,
            "type" to "chromecast",
            "isAvailable" to true
        )
        
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("onDeviceFound", deviceMap)
        }
    }
    
    private fun notifyDeviceConnected(device: CastDevice) {
        val deviceMap = mapOf(
            "id" to device.deviceId,
            "name" to device.friendlyName,
            "type" to "chromecast",
            "isAvailable" to true
        )
        
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("onDeviceConnected", deviceMap)
        }
    }
    
    private fun notifyDeviceDisconnected() {
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("onDeviceDisconnected", null)
        }
    }
    
    private fun notifyCastError(error: String) {
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("onCastError", error)
        }
    }
}
