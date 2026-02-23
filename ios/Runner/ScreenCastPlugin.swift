import Flutter
import UIKit
import AVKit
import MediaPlayer

public class ScreenCastPlugin: NSObject, FlutterPlugin {
    private var channel: FlutterMethodChannel?
    private var routePickerView: AVRoutePickerView?
    private var volumeView: MPVolumeView?
    private var isMonitoring = false
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.vga.alqadiya/screen_cast", binaryMessenger: registrar.messenger())
        let instance = ScreenCastPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
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
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func startScanning(result: @escaping FlutterResult) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if !self.isMonitoring {
                self.startMonitoringAirPlayDevices()
            }
            
            // Scan for available AirPlay devices
            self.scanForAirPlayDevices()
            
            result(true)
        }
    }
    
    private func stopScanning(result: @escaping FlutterResult) {
        DispatchQueue.main.async { [weak self] in
            self?.stopMonitoringAirPlayDevices()
            result(true)
        }
    }
    
    private func connectToDevice(call: FlutterMethodCall, result: @escaping FlutterResult) {
        // AirPlay connection is handled automatically by the system
        // This method is called after user selects a device from the picker
        result(true)
    }
    
    private func disconnect(result: @escaping FlutterResult) {
        DispatchQueue.main.async {
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
        DispatchQueue.main.async {
            let isConnected = self.isAirPlayActive()
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
            
            // Get the root view controller
            guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
                result(FlutterError(code: "NO_VIEW_CONTROLLER", message: "Root view controller not available", details: nil))
                return
            }
            
            // Create and show AirPlay picker
            let routePickerView = AVRoutePickerView()
            routePickerView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            routePickerView.tintColor = .white
            routePickerView.activeTintColor = .systemBlue
            
            // Find the button and trigger it
            for view in routePickerView.subviews {
                if let button = view as? UIButton {
                    button.sendActions(for: .touchUpInside)
                    break
                }
            }
            
            self.routePickerView = routePickerView
            result(true)
        }
    }
    
    private func startMonitoringAirPlayDevices() {
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
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }
        
        switch reason {
        case .newDeviceAvailable:
            if isAirPlayActive() {
                notifyDeviceConnected()
            }
        case .oldDeviceUnavailable:
            notifyDeviceDisconnected()
        default:
            break
        }
    }
    
    @objc private func handleScreenConnect(notification: Notification) {
        if let screen = notification.object as? UIScreen {
            let deviceInfo: [String: Any] = [
                "id": screen.description,
                "name": "AirPlay Display",
                "type": "airplay",
                "isAvailable": true
            ]
            notifyDeviceFound(deviceInfo: deviceInfo)
            notifyDeviceConnected(deviceInfo: deviceInfo)
        }
    }
    
    @objc private func handleScreenDisconnect(notification: Notification) {
        notifyDeviceDisconnected()
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
