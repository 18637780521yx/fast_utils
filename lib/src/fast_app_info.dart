import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 应用 / 设备 / 唯一标识 信息工具类。
///
/// 使用前需要先调用一次 [FastAppInfo.init] 完成初始化。
class FastAppInfo {
  /// 应用包信息（名称、版本号、构建号等），来源于 package_info_plus。
  static late final PackageInfo packageInfo;

  /// 设备唯一标识，由 flutter_udid 提供（跨平台统一 ID）。
  static late final String udid;

  /// 设备信息，实际类型为 [AndroidDeviceInfo] / [IosDeviceInfo] 等，
  /// 通过 [BaseDeviceInfo] 抽象暴露出来。
  static late final BaseDeviceInfo deviceInfo;

  /// Android 设备信息（仅在 Android 平台可用，其他平台返回 null）。
  static AndroidDeviceInfo get androidDeviceInfo => deviceInfo as AndroidDeviceInfo;

  /// iOS 设备信息（仅在 iOS 平台可用，其他平台返回 null）。
  static IosDeviceInfo get iosDeviceInfo => deviceInfo as IosDeviceInfo;

  /// 初始化方法，在 App 启动时调用一次即可。
  ///
  /// 示例：
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await FastAppInfo.init();
  ///   runApp(const MyApp());
  /// }
  /// ```
  static Future<void> init() async {
    // 获取应用包信息
    packageInfo = await PackageInfo.fromPlatform();

    // 获取当前平台对应的设备信息
    final deviceInfoPlugin = DeviceInfoPlugin();
    deviceInfo = await deviceInfoPlugin.deviceInfo;

    // 获取设备唯一标识
    udid = await FlutterUdid.udid;
  }
}
