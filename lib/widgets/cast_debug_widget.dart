import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/services/screen_cast_service.dart';

/// Debug widget to test cast functionality
/// Add this to any screen to test casting
class CastDebugWidget extends StatelessWidget {
  const CastDebugWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final castService = Get.find<ScreenCastService>();

    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Cast Debug Panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Status indicators
            _buildStatusRow('Connected', castService.isConnected.value),
            _buildStatusRow('Scanning', castService.isScanning.value),
            const SizedBox(height: 8),

            // Connected device info
            if (castService.connectedDevice.value != null) ...[
              const Divider(color: Colors.white24),
              const Text(
                'Connected Device:',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                castService.connectedDevice.value!.name,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              Text(
                'Type: ${castService.connectedDevice.value!.type}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],

            // Available devices
            if (castService.availableDevices.isNotEmpty) ...[
              const Divider(color: Colors.white24),
              const Text(
                'Available Devices:',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 4),
              ...castService.availableDevices.map(
                (device) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '• ${device.name} (${device.type})',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 12),
            const Divider(color: Colors.white24),
            const SizedBox(height: 8),

            // Action buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildButton(
                  'Show Picker',
                  Icons.cast,
                  () => castService.showCastPicker(),
                ),
                _buildButton(
                  'Start Scan',
                  Icons.search,
                  () => castService.startScanning(),
                  enabled: !castService.isScanning.value,
                ),
                _buildButton(
                  'Stop Scan',
                  Icons.stop,
                  () => castService.stopScanning(),
                  enabled: castService.isScanning.value,
                ),
                if (castService.isConnected.value)
                  _buildButton(
                    'Disconnect',
                    Icons.close,
                    () => castService.disconnect(),
                    color: Colors.red,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: value ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool enabled = true,
    Color? color,
  }) {
    return ElevatedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontSize: 12),
      ),
    );
  }
}
