# Screen Casting Implementation Guide

## Overview
This app now includes professional screen casting/mirroring functionality that works on both Android and iOS platforms.

## Features

### Android (Google Cast / Chromecast)
- ✅ Automatic device discovery on local network
- ✅ Connect to Chromecast devices
- ✅ Screen mirroring support
- ✅ Real-time connection status
- ✅ Native Cast picker UI
- ✅ Session management with auto-reconnect

### iOS (AirPlay)
- ✅ AirPlay device discovery
- ✅ Connect to Apple TV and AirPlay-enabled devices
- ✅ Screen mirroring support
- ✅ Real-time connection monitoring
- ✅ Native AirPlay picker UI
- ✅ External display support

## How It Works

### User Experience
1. User taps the **chromecast icon** in the app header
2. A native picker dialog appears showing available devices
3. User selects a device to connect
4. **Green indicator** appears on the chromecast icon when connected
5. App content is mirrored to the selected device
6. User can tap again to disconnect or switch devices

### Technical Implementation

#### Flutter Layer (`lib/core/services/screen_cast_service.dart`)
- `ScreenCastService` - Main service managing cast functionality
- Observable states for connection status
- Device discovery and management
- Platform channel communication
- Custom cast device picker dialog

#### Android Layer
- `ScreenCastPlugin.kt` - Platform channel implementation
- `CastOptionsProvider.kt` - Google Cast SDK configuration
- Uses Google Cast Framework 21.5.0
- Supports Chromecast and Cast-enabled devices

#### iOS Layer
- `ScreenCastPlugin.swift` - Platform channel implementation
- Uses AVKit and MediaPlayer frameworks
- Supports AirPlay and external displays
- Background audio mode for continuous casting

## Setup & Configuration

### Android Setup
1. **Dependencies** (already added):
   ```kotlin
   implementation("com.google.android.gms:play-services-cast-framework:21.5.0")
   implementation("androidx.mediarouter:mediarouter:1.7.0")
   ```

2. **AndroidManifest.xml** (already configured):
   ```xml
   <meta-data
       android:name="com.google.android.gms.cast.framework.OPTIONS_PROVIDER_CLASS_NAME"
       android:value="com.vga.alqadiya.CastOptionsProvider" />
   ```

3. **Receiver App ID**: Currently using default Media Receiver (`CC1AD845`)
   - For custom branding, register a custom receiver app at [Google Cast SDK Developer Console](https://cast.google.com/publish)

### iOS Setup
1. **Info.plist** (already configured):
   ```xml
   <key>UIBackgroundModes</key>
   <array>
       <string>audio</string>
       <string>external-accessory</string>
   </array>
   ```

2. **Capabilities**: Audio background mode enabled for continuous casting

## Usage in Code

### Basic Usage
The casting functionality is automatically integrated into all screens using `HomeHeader`:

```dart
HomeHeader(
  title: Text('My Screen'),
  actionButtons: Row(
    children: [
      // Other action buttons
    ],
  ),
)
```

The chromecast icon automatically:
- Shows the cast picker when tapped
- Displays a green indicator when connected
- Handles all connection management

### Advanced Usage

#### Manually trigger cast picker:
```dart
final castService = Get.find<ScreenCastService>();
castService.showCastPicker();
```

#### Check connection status:
```dart
final castService = Get.find<ScreenCastService>();
if (castService.isConnected.value) {
  print('Connected to: ${castService.connectedDevice.value?.name}');
}
```

#### Listen to connection changes:
```dart
final castService = Get.find<ScreenCastService>();
castService.isConnected.listen((connected) {
  if (connected) {
    print('Device connected!');
  } else {
    print('Device disconnected!');
  }
});
```

#### Scan for devices:
```dart
final castService = Get.find<ScreenCastService>();
await castService.startScanning();

// Access discovered devices
castService.availableDevices.forEach((device) {
  print('Found: ${device.name} (${device.type})');
});
```

#### Connect to specific device:
```dart
final castService = Get.find<ScreenCastService>();
final device = castService.availableDevices.first;
final success = await castService.connectToDevice(device);
```

#### Disconnect:
```dart
final castService = Get.find<ScreenCastService>();
await castService.disconnect();
```

## Localization

All casting-related strings are localized in both English and Arabic:

- `Cast to Device` / `البث إلى الجهاز`
- `Scanning for devices...` / `البحث عن الأجهزة...`
- `No devices found` / `لم يتم العثور على أجهزة`
- `Connected` / `متصل`
- `Disconnected` / `غير متصل`
- `Cast Error` / `خطأ في البث`

## Troubleshooting

### Android
**Issue**: No devices found
- Ensure device and Chromecast are on the same WiFi network
- Check that Google Play Services is up to date
- Verify Cast-enabled devices are powered on

**Issue**: Connection fails
- Restart the Chromecast device
- Clear app cache and try again
- Check firewall settings on network

### iOS
**Issue**: AirPlay not showing
- Ensure device and Apple TV are on the same WiFi network
- Check that AirPlay is enabled on Apple TV
- Verify iOS device has iOS 11.0 or later

**Issue**: Connection drops
- Check WiFi signal strength
- Disable VPN if active
- Restart both devices

## Testing

### Android Testing
1. Install app on Android device
2. Ensure Chromecast is on same network
3. Tap chromecast icon
4. Select Chromecast from list
5. Verify green indicator appears
6. Verify app content appears on TV

### iOS Testing
1. Install app on iOS device
2. Ensure Apple TV is on same network
3. Tap chromecast icon
4. Select AirPlay device from list
5. Verify green indicator appears
6. Verify app content appears on TV

## Performance Considerations

- **Battery**: Casting uses additional battery; inform users
- **Network**: Requires stable WiFi connection
- **Latency**: Expect 1-2 second delay in mirroring
- **Quality**: Depends on network bandwidth

## Future Enhancements

Possible improvements:
- [ ] Custom receiver app with branding
- [ ] Cast-specific UI optimizations
- [ ] Volume control integration
- [ ] Multi-room audio support
- [ ] Cast queue management
- [ ] Analytics for cast usage

## Support

For issues or questions:
1. Check device compatibility
2. Verify network configuration
3. Review logs for error messages
4. Test with different cast devices

## References

- [Google Cast SDK Documentation](https://developers.google.com/cast)
- [Apple AirPlay Documentation](https://developer.apple.com/airplay/)
- [Flutter Platform Channels](https://flutter.dev/docs/development/platform-integration/platform-channels)
