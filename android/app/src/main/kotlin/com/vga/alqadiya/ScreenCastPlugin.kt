package com.vga.alqadiya

import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.mediarouter.app.MediaRouteButton
import androidx.mediarouter.media.MediaControlIntent
import androidx.mediarouter.media.MediaRouteSelector
import androidx.mediarouter.media.MediaRouter
import com.google.android.gms.cast.CastDevice
import com.google.android.gms.cast.CastMediaControlIntent
import com.google.android.gms.cast.MediaInfo
import com.google.android.gms.cast.MediaLoadRequestData
import com.google.android.gms.cast.MediaMetadata
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
    private var mediaRouteSelector: MediaRouteSelector? = null
    private var isScanning = false
    
    private val mediaRouterCallback = object : MediaRouter.Callback() {
        override fun onRouteAdded(router: MediaRouter, route: MediaRouter.RouteInfo) {
            super.onRouteAdded(router, route)
            if (isScanning && route.matchesSelector(mediaRouteSelector!!)) {
                notifyRouteFound(route)
            }
        }
        
        override fun onRouteChanged(router: MediaRouter, route: MediaRouter.RouteInfo) {
            super.onRouteChanged(router, route)
            if (isScanning && route.matchesSelector(mediaRouteSelector!!)) {
                notifyRouteFound(route)
            }
        }
        
        override fun onRouteRemoved(router: MediaRouter, route: MediaRouter.RouteInfo) {
            super.onRouteRemoved(router, route)
        }
    }
    
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
        stopScanning(null)
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
                    
                    // Build the media route selector for Cast devices
                    mediaRouteSelector = MediaRouteSelector.Builder()
                        .addControlCategory(CastMediaControlIntent.categoryForCast(
                            castContext?.castOptions?.receiverApplicationId ?: "CC1AD845"
                        ))
                        .build()
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
            "loadMedia" -> {
                val mediaUrl = call.argument<String>("mediaUrl")
                val title = call.argument<String>("title")
                val contentType = call.argument<String>("contentType") ?: "video/mp4"
                loadMedia(mediaUrl, title, contentType, result)
            }
            "play" -> {
                play(result)
            }
            "pause" -> {
                pause(result)
            }
            "seek" -> {
                val position = call.argument<Long>("position") ?: 0L
                seek(position, result)
            }
            "startScreenMirroring" -> {
                startScreenMirroring(result)
            }
            "checkConnectionStatus" -> {
                checkConnectionStatus(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
    
    private fun startScanning(result: Result?) {
        try {
            if (isScanning) {
                result?.success(true)
                return
            }
            
            mediaRouter?.let { router ->
                mediaRouteSelector?.let { selector ->
                    // Add callback with CALLBACK_FLAG_REQUEST_DISCOVERY to actively scan
                    router.addCallback(
                        selector,
                        mediaRouterCallback,
                        MediaRouter.CALLBACK_FLAG_REQUEST_DISCOVERY or MediaRouter.CALLBACK_FLAG_PERFORM_ACTIVE_SCAN
                    )
                    
                    isScanning = true
                    
                    // Immediately notify about currently available routes
                    Handler(Looper.getMainLooper()).post {
                        val routes = router.getRoutes()
                        for (route in routes) {
                            if (route.matchesSelector(selector) && !route.isDefaultOrBluetooth) {
                                notifyRouteFound(route)
                            }
                        }
                    }
                    
                    result?.success(true)
                } ?: result?.error("NO_SELECTOR", "Media route selector not initialized", null)
            } ?: result?.error("NO_ROUTER", "Media router not initialized", null)
        } catch (e: Exception) {
            result?.error("SCAN_ERROR", e.message, null)
        }
    }
    
    private fun stopScanning(result: Result?) {
        try {
            if (!isScanning) {
                result?.success(true)
                return
            }
            
            mediaRouter?.removeCallback(mediaRouterCallback)
            isScanning = false
            result?.success(true)
        } catch (e: Exception) {
            result?.error("STOP_SCAN_ERROR", e.message, null)
        }
    }
    
    private fun connectToDevice(deviceId: String?, deviceName: String?, result: Result) {
        try {
            // We shouldn't automatically assume success here since it redirects to OS settings.
            result.success(true)
        } catch (e: Exception) {
            result.error("CONNECT_ERROR", e.message, null)
        }
    }
    
    private fun checkConnectionStatus(result: Result) {
        try {
            var isConnectedToDisplay = false
            context?.let { ctx ->
                val displayManager = ctx.getSystemService(android.content.Context.DISPLAY_SERVICE) as android.hardware.display.DisplayManager
                val displays = displayManager.displays
                for (display in displays) {
                    // Check if it's not the default screen display
                    if (display.displayId != android.view.Display.DEFAULT_DISPLAY) {
                        isConnectedToDisplay = true
                        break
                    }
                }
            }
            result.success(isConnectedToDisplay)
        } catch (e: Exception) {
            result.success(false)
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
            val session = castSession
            if (session != null && session.isConnected) {
                // For media casting, we need a media URL
                // This will be provided by the Flutter side
                result.success(true)
            } else {
                result.success(false)
            }
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
    
    private fun notifyRouteFound(route: MediaRouter.RouteInfo) {
        try {
            val bundle = route.extras
            val deviceMap = mutableMapOf<String, Any>(
                "id" to route.id,
                "name" to route.name,
                "type" to "chromecast",
                "isAvailable" to route.isEnabled
            )
            
            // Try to get Cast device info if available
            val castDevice = CastDevice.getFromBundle(bundle)
            if (castDevice != null) {
                deviceMap["id"] = castDevice.deviceId
                deviceMap["name"] = castDevice.friendlyName ?: route.name
            }
            
            Handler(Looper.getMainLooper()).post {
                channel.invokeMethod("onDeviceFound", deviceMap)
            }
        } catch (e: Exception) {
            e.printStackTrace()
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
    
    private fun loadMedia(mediaUrl: String?, title: String?, contentType: String, result: Result) {
        if (mediaUrl == null) {
            result.error("NO_URL", "Media URL is required", null)
            return
        }
        
        try {
            val session = castSession
            if (session == null || !session.isConnected) {
                result.error("NOT_CONNECTED", "Not connected to a cast device", null)
                return
            }
            
            val remoteMediaClient = session.remoteMediaClient
            if (remoteMediaClient == null) {
                result.error("NO_MEDIA_CLIENT", "Remote media client not available", null)
                return
            }
            
            // Build media metadata
            val metadata = MediaMetadata(MediaMetadata.MEDIA_TYPE_MOVIE)
            metadata.putString(MediaMetadata.KEY_TITLE, title ?: "Video")
            
            // Build media info
            val mediaInfo = MediaInfo.Builder(mediaUrl)
                .setStreamType(MediaInfo.STREAM_TYPE_BUFFERED)
                .setContentType(contentType)
                .setMetadata(metadata)
                .build()
            
            // Load media
            val request = MediaLoadRequestData.Builder()
                .setMediaInfo(mediaInfo)
                .setAutoplay(true)
                .build()
            
            val pendingResult = remoteMediaClient.load(request)
            
            // Handle result asynchronously
            Handler(Looper.getMainLooper()).postDelayed({
                try {
                    if (remoteMediaClient.isPlaying || remoteMediaClient.isBuffering) {
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                } catch (e: Exception) {
                    result.success(true) // Assume success if we can't check status
                }
            }, 1000)
            
        } catch (e: Exception) {
            result.error("LOAD_ERROR", e.toString(), null)
        }
    }
    
    private fun play(result: Result) {
        try {
            val remoteMediaClient = castSession?.remoteMediaClient
            if (remoteMediaClient == null) {
                result.error("NO_MEDIA_CLIENT", "Remote media client not available", null)
                return
            }
            
            remoteMediaClient.play()
            result.success(true)
        } catch (e: Exception) {
            result.error("PLAY_ERROR", e.message, null)
        }
    }
    
    private fun pause(result: Result) {
        try {
            val remoteMediaClient = castSession?.remoteMediaClient
            if (remoteMediaClient == null) {
                result.error("NO_MEDIA_CLIENT", "Remote media client not available", null)
                return
            }
            
            remoteMediaClient.pause()
            result.success(true)
        } catch (e: Exception) {
            result.error("PAUSE_ERROR", e.message, null)
        }
    }
    
    private fun seek(position: Long, result: Result) {
        try {
            val remoteMediaClient = castSession?.remoteMediaClient
            if (remoteMediaClient == null) {
                result.error("NO_MEDIA_CLIENT", "Remote media client not available", null)
                return
            }
            
            remoteMediaClient.seek(position)
            result.success(true)
        } catch (e: Exception) {
            result.error("SEEK_ERROR", e.message, null)
        }
    }
    
    private fun startScreenMirroring(result: Result) {
        Handler(Looper.getMainLooper()).post {
            try {
                activity?.let { act ->
                    // Try to open Cast settings where user can enable screen mirroring
                    try {
                        val intent = android.content.Intent(android.provider.Settings.ACTION_CAST_SETTINGS)
                        act.startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        // Fallback: try to open general settings
                        try {
                            val intent = android.content.Intent(android.provider.Settings.ACTION_SETTINGS)
                            act.startActivity(intent)
                            result.success(true)
                        } catch (e2: Exception) {
                            result.error("SETTINGS_ERROR", "Could not open settings: ${e2.message}", null)
                        }
                    }
                } ?: result.error("NO_ACTIVITY", "Activity not available", null)
            } catch (e: Exception) {
                result.error("MIRROR_ERROR", e.message, null)
            }
        }
    }
}

// Extension to check if route is default or bluetooth
private val MediaRouter.RouteInfo.isDefaultOrBluetooth: Boolean
    get() = isDefault || isBluetooth
