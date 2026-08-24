import Flutter
import UIKit
import AVKit
import MediaPlayer
import AVFoundation

public class ScreenCastPlugin: NSObject, FlutterPlugin {
    private var channel: FlutterMethodChannel?
    private var routePickerView: AVRoutePickerView?
    private var volumeView: MPVolumeView?
    private var isMonitoring = false
    private var avPlayer: AVPlayer?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.vga.alqadiya/screen_cast", binaryMessenger: registrar.messenger())
        let instance = ScreenCastPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        // Start monitoring immediately so screen sharing/AirPlay connection status is tracked
        instance.startMonitoringAirPlayDevices()
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startScanning":
            startScanning(result: result)
        case "stopScanning":
            stopScanning(result: result)
        case "connectToDevice":
            connectToDevice(call: call, result: result)
        case "disconnect":
            disconnect(result: result)
        case "startMirroring":
            startMirroring(result: result)
        case "stopMirroring":
            stopMirroring(result: result)
        case "showCastPicker":
            showCastPicker(result: result)
        case "checkConnectionStatus":
            checkConnectionStatus(result: result)
        case "startScreenMirroring":
            startScreenMirroring(result: result)
        case "loadMedia":
            loadMedia(call: call, result: result)
        case "play":
            play(result: result)
        case "pause":
            pause(result: result)
        case "seek":
            seek(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func startScanning(result: @escaping FlutterResult) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Observers are already active, just check current state and scan
            self.scanForAirPlayDevices()
            
            result(true)
        }
    }
    
    private func stopScanning(result: @escaping FlutterResult) {
        DispatchQueue.main.async {
            // Keep observers active for continuous connection status updates
            result(true)
        }
    }
    
    private func connectToDevice(call: FlutterMethodCall, result: @escaping FlutterResult) {
        // AirPlay connection is handled automatically by the system
        result(true)
    }
    
    private func disconnect(result: @escaping FlutterResult) {
        DispatchQueue.main.async { [weak self] in
            // Stop avPlayer if playing
            self?.avPlayer?.pause()
            self?.avPlayer = nil
            
            // Disconnect from AirPlay
            if let volumeView = MPVolumeView() as? MPVolumeView {
                for view in volumeView.subviews {
                    if let button = view as? UIButton {
                        button.sendActions(for: .touchUpInside)
                    }
                }
            }
            result(true)
        }
    }
    
    private func startMirroring(result: @escaping FlutterResult) {
        DispatchQueue.main.async { [weak self] in
            let isConnected = self?.isAirPlayActive() ?? false
            result(isConnected)
        }
    }
    
    private func stopMirroring(result: @escaping FlutterResult) {
        // Mirroring stops when AirPlay is disconnected
        result(true)
    }
    
    private func showCastPicker(result: @escaping FlutterResult) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                result(FlutterError(code: "NO_INSTANCE", message: "Plugin instance not available", details: nil))
                return
            }
            
            // Get the root view controller using modern API
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                result(FlutterError(code: "NO_VIEW_CONTROLLER", message: "Root view controller not available", details: nil))
                return
            }
            
            // Create and show AirPlay picker
            let routePickerView = AVRoutePickerView()
            routePickerView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            routePickerView.tintColor = .white
            routePickerView.activeTintColor = .systemBlue
            routePickerView.prioritizesVideoDevices = true
            
            // Add to view hierarchy temporarily
            rootViewController.view.addSubview(routePickerView)
            
            // Helper function to find button recursively
            func findButton(in view: UIView) -> UIButton? {
                if let button = view as? UIButton {
                    return button
                }
                for subview in view.subviews {
                    if let button = findButton(in: subview) {
                        return button
                    }
                }
                return nil
            }
            
            // Find the button and trigger it
            if let button = findButton(in: routePickerView) {
                button.sendActions(for: .touchUpInside)
                
                // Remove after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    routePickerView.removeFromSuperview()
                }
                self.routePickerView = routePickerView
                result(true)
            } else {
                print("Failed to find button in AVRoutePickerView")
                routePickerView.removeFromSuperview()
                result(FlutterError(code: "PICKER_ERROR", message: "Failed to find native picker button", details: nil))
            }
        }
    }
    
    private func checkConnectionStatus(result: @escaping FlutterResult) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                result(false)
                return
            }
            result(self.isAirPlayActive())
        }
    }
    
    private func startScreenMirroring(result: @escaping FlutterResult) {
        DispatchQueue.main.async {
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                result(false)
                return
            }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { success in
                    result(success)
                }
            } else {
                result(false)
            }
        }
    }
    
    private func loadMedia(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let mediaUrlString = args["mediaUrl"] as? String,
              let url = URL(string: mediaUrlString) else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Media URL is missing or invalid", details: nil))
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Set up audio session to support AirPlay video playback
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Failed to set AVAudioSession category: \(error)")
            }
            
            self.avPlayer = AVPlayer(url: url)
            
            // Allow external playback (AirPlay)
            self.avPlayer?.allowsExternalPlayback = true
            self.avPlayer?.usesExternalPlaybackWhileExternalScreenIsActive = true
            
            self.avPlayer?.play()
            result(true)
        }
    }
    
    private func play(result: @escaping FlutterResult) {
        DispatchQueue.main.async { [weak self] in
            self?.avPlayer?.play()
            result(true)
        }
    }
    
    private func pause(result: @escaping FlutterResult) {
        DispatchQueue.main.async { [weak self] in
            self?.avPlayer?.pause()
            result(true)
        }
    }
    
    private func seek(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let positionMs = args["position"] as? Int64 else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Position is missing", details: nil))
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            let time = CMTime(value: positionMs, timescale: 1000)
            self?.avPlayer?.seek(to: time) { finished in
                result(finished)
            }
        }
    }
    
    private func startMonitoringAirPlayDevices() {
        if isMonitoring { return }
        isMonitoring = true
        
        // Monitor AirPlay route changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRouteChange),
            name: AVAudioSession.routeChangeNotification,
            object: nil
        )
        
        // Monitor external screen connections
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleScreenConnect),
            name: UIScreen.didConnectNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleScreenDisconnect),
            name: UIScreen.didDisconnectNotification,
            object: nil
        )
    }
    
    private func stopMonitoringAirPlayDevices() {
        isMonitoring = false
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleRouteChange(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.isAirPlayActive() {
                self.notifyDeviceConnected()
            } else {
                self.notifyDeviceDisconnected()
            }
        }
    }
    
    @objc private func handleScreenConnect(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let screen = notification.object as? UIScreen {
                let deviceInfo: [String: Any] = [
                    "id": screen.description,
                    "name": "AirPlay Display",
                    "type": "airplay",
                    "isAvailable": true
                ]
                self.notifyDeviceFound(deviceInfo: deviceInfo)
                self.notifyDeviceConnected(deviceInfo: deviceInfo)
            }
        }
    }
    
    @objc private func handleScreenDisconnect(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.notifyDeviceDisconnected()
        }
    }
    
    private func scanForAirPlayDevices() {
        // Check if AirPlay is currently active
        if isAirPlayActive() {
            let deviceInfo: [String: Any] = [
                "id": "airplay_device",
                "name": "AirPlay Device",
                "type": "airplay",
                "isAvailable": true
            ]
            notifyDeviceFound(deviceInfo: deviceInfo)
        }
        
        // Check for external screens
        for screen in UIScreen.screens where screen != UIScreen.main {
            let deviceInfo: [String: Any] = [
                "id": screen.description,
                "name": "External Display",
                "type": "airplay",
                "isAvailable": true
            ]
            notifyDeviceFound(deviceInfo: deviceInfo)
        }
    }
    
    private func isAirPlayActive() -> Bool {
        // Check if there are external screens connected
        if UIScreen.screens.count > 1 {
            return true
        }
        
        // Check audio route for AirPlay
        let audioSession = AVAudioSession.sharedInstance()
        let currentRoute = audioSession.currentRoute
        
        for output in currentRoute.outputs {
            if output.portType == .airPlay {
                return true
            }
        }
        
        return false
    }
    
    private func notifyDeviceFound(deviceInfo: [String: Any]) {
        DispatchQueue.main.async { [weak self] in
            self?.channel?.invokeMethod("onDeviceFound", arguments: deviceInfo)
        }
    }
    
    private func notifyDeviceConnected(deviceInfo: [String: Any]? = nil) {
        DispatchQueue.main.async { [weak self] in
            let info = deviceInfo ?? [
                "id": "airplay_device",
                "name": "AirPlay Device",
                "type": "airplay",
                "isAvailable": true
            ]
            self?.channel?.invokeMethod("onDeviceConnected", arguments: info)
        }
    }
    
    private func notifyDeviceDisconnected() {
        DispatchQueue.main.async { [weak self] in
            self?.channel?.invokeMethod("onDeviceDisconnected", arguments: nil)
        }
    }
    
    private func notifyCastError(error: String) {
        DispatchQueue.main.async { [weak self] in
            self?.channel?.invokeMethod("onCastError", arguments: error)
        }
    }
    
    deinit {
        stopMonitoringAirPlayDevices()
    }
}
