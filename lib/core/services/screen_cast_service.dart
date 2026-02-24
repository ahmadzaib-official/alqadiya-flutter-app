import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Screen casting service for mirroring app content to external displays
/// Supports both native casting (Chromecast, AirPlay) and screen mirroring
class ScreenCastService extends GetxService {
  static const MethodChannel _channel = MethodChannel(
    'com.vga.alqadiya/screen_cast',
  );

  // Observable states
  final RxBool isConnected = false.obs;
  final RxBool isScanning = false.obs;
  final RxList<CastDevice> availableDevices = <CastDevice>[].obs;
  final Rx<CastDevice?> connectedDevice = Rx<CastDevice?>(null);

  StreamSubscription? _deviceSubscription;

  @override
  void onInit() {
    super.onInit();
    _setupMethodCallHandler();
    // Auto-start scanning when service initializes
    Future.delayed(const Duration(milliseconds: 500), () {
      startScanning();
    });
  }

  @override
  void onClose() {
    _deviceSubscription?.cancel();
    disconnect();
    super.onClose();
  }

  /// Setup method call handler for native callbacks
  void _setupMethodCallHandler() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onDeviceFound':
          _handleDeviceFound(call.arguments);
          break;
        case 'onDeviceConnected':
          _handleDeviceConnected(call.arguments);
          break;
        case 'onDeviceDisconnected':
          _handleDeviceDisconnected();
          break;
        case 'onCastError':
          _handleCastError(call.arguments);
          break;
      }
    });
  }

  /// Start scanning for available cast devices
  Future<void> startScanning() async {
    try {
      isScanning.value = true;
      availableDevices.clear();

      final result = await _channel.invokeMethod('startScanning');
      log('Started scanning for cast devices: $result');
    } on PlatformException catch (e) {
      log('Error starting scan: ${e.message}');
      _showError('Failed to scan for devices: ${e.message}');
    } finally {
      // Auto-stop scanning after 30 seconds
      Future.delayed(const Duration(seconds: 30), () {
        if (isScanning.value) {
          stopScanning();
        }
      });
    }
  }

  /// Stop scanning for devices
  Future<void> stopScanning() async {
    try {
      await _channel.invokeMethod('stopScanning');
      isScanning.value = false;
      log('Stopped scanning for cast devices');
    } on PlatformException catch (e) {
      log('Error stopping scan: ${e.message}');
    }
  }

  /// Connect to a specific cast device
  Future<bool> connectToDevice(CastDevice device) async {
    try {
      final result = await _channel.invokeMethod('connectToDevice', {
        'deviceId': device.id,
        'deviceName': device.name,
        'deviceType': device.type,
      });

      if (result == true) {
        connectedDevice.value = device;
        isConnected.value = true;
        log('Connected to device: ${device.name}');
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      log('Error connecting to device: ${e.message}');
      _showError('Failed to connect: ${e.message}');
      return false;
    }
  }

  /// Disconnect from current cast device
  Future<void> disconnect() async {
    try {
      await _channel.invokeMethod('disconnect');
      isConnected.value = false;
      connectedDevice.value = null;
      log('Disconnected from cast device');
    } on PlatformException catch (e) {
      log('Error disconnecting: ${e.message}');
    }
  }

  /// Start screen mirroring
  Future<bool> startMirroring() async {
    try {
      final result = await _channel.invokeMethod('startMirroring');
      log('Screen mirroring started: $result');
      return result == true;
    } on PlatformException catch (e) {
      log('Error starting mirroring: ${e.message}');
      _showError('Failed to start mirroring: ${e.message}');
      return false;
    }
  }

  /// Stop screen mirroring
  Future<void> stopMirroring() async {
    try {
      await _channel.invokeMethod('stopMirroring');
      log('Screen mirroring stopped');
    } on PlatformException catch (e) {
      log('Error stopping mirroring: ${e.message}');
    }
  }

  /// Show cast device picker dialog (native UI)
  Future<void> showCastPicker() async {
    try {
      await _channel.invokeMethod('showCastPicker');
    } on PlatformException catch (e) {
      log('Error showing cast picker: ${e.message}');
      // Fallback to custom dialog
      _showCustomCastDialog();
    }
  }

  /// Handle device found callback
  void _handleDeviceFound(dynamic arguments) {
    try {
      final deviceData = Map<String, dynamic>.from(arguments);
      final device = CastDevice.fromMap(deviceData);

      // Add device if not already in list
      if (!availableDevices.any((d) => d.id == device.id)) {
        availableDevices.add(device);
        log('Found cast device: ${device.name}');
      }
    } catch (e) {
      log('Error handling device found: $e');
    }
  }

  /// Handle device connected callback
  void _handleDeviceConnected(dynamic arguments) {
    try {
      final deviceData = Map<String, dynamic>.from(arguments);
      final device = CastDevice.fromMap(deviceData);

      connectedDevice.value = device;
      isConnected.value = true;

      Get.snackbar(
        'Connected'.tr,
        'Connected to ${device.name}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      log('Error handling device connected: $e');
    }
  }

  /// Handle device disconnected callback
  void _handleDeviceDisconnected() {
    final deviceName = connectedDevice.value?.name ?? 'device';

    isConnected.value = false;
    connectedDevice.value = null;

    Get.snackbar(
      'Disconnected'.tr,
      'Disconnected from $deviceName',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  /// Handle cast error callback
  void _handleCastError(dynamic arguments) {
    final error = arguments.toString();
    log('Cast error: $error');
    _showError(error);
  }

  /// Show error message
  void _showError(String message) {
    Get.snackbar(
      'Cast Error'.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  /// Show custom cast device selection dialog
  void _showCustomCastDialog() {
    Get.dialog(CastDeviceDialog(service: this), barrierDismissible: true);
  }
}

/// Cast device model
class CastDevice {
  final String id;
  final String name;
  final String type; // 'chromecast', 'airplay', 'miracast', etc.
  final bool isAvailable;

  CastDevice({
    required this.id,
    required this.name,
    required this.type,
    this.isAvailable = true,
  });

  factory CastDevice.fromMap(Map<String, dynamic> map) {
    return CastDevice(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Unknown Device',
      type: map['type'] ?? 'unknown',
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'type': type, 'isAvailable': isAvailable};
  }

  IconData get icon {
    switch (type.toLowerCase()) {
      case 'chromecast':
        return Icons.cast;
      case 'airplay':
        return Icons.airplay;
      case 'miracast':
        return Icons.screen_share;
      default:
        return Icons.devices;
    }
  }
}

/// Cast device selection dialog
class CastDeviceDialog extends StatelessWidget {
  final ScreenCastService service;

  const CastDeviceDialog({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cast to Device'.tr),
      content: SizedBox(
        width: double.maxFinite,
        child: Obx(() {
          if (service.isScanning.value && service.availableDevices.isEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text('Scanning for devices...'.tr),
              ],
            );
          }

          if (service.availableDevices.isEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.devices_other, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No devices found'.tr,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Make sure your casting device is on the same network'.tr,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: service.availableDevices.length,
            itemBuilder: (context, index) {
              final device = service.availableDevices[index];
              final isConnected =
                  service.connectedDevice.value?.id == device.id;

              return ListTile(
                leading: Icon(device.icon),
                title: Text(device.name),
                subtitle: Text(device.type.toUpperCase()),
                trailing:
                    isConnected
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                onTap:
                    isConnected
                        ? null
                        : () async {
                          final success = await service.connectToDevice(device);
                          if (success) {
                            Get.back();
                          }
                        },
              );
            },
          );
        }),
      ),
      actions: [
        if (service.isConnected.value)
          TextButton(
            onPressed: () {
              service.disconnect();
              Get.back();
            },
            child: Text('Disconnect'.tr),
          ),
        TextButton(
          onPressed: () {
            if (service.isScanning.value) {
              service.stopScanning();
            } else {
              service.startScanning();
            }
          },
          child: Obx(
            () => Text(
              service.isScanning.value ? 'Stop Scanning'.tr : 'Scan Again'.tr,
            ),
          ),
        ),
        TextButton(onPressed: () => Get.back(), child: Text('Close'.tr)),
      ],
    );
  }
}
