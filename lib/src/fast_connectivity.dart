import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// 网络连接状态。
enum FastNetworkStatus {
  /// 无网络
  none,

  /// Wi‑Fi
  wifi,

  /// 蜂窝移动网络（4G/5G 等）
  mobile,

  /// 有线网络
  ethernet,

  /// VPN
  vpn,

  /// 蓝牙共享网络
  bluetooth,

  /// 其他类型或未知
  other,
}

/// 网络连接监听工具类。
///
/// 封装了 connectivity_plus，提供当前网络状态和变更监听。
class FastConnectivity {
  FastConnectivity._();

  static final Connectivity _connectivity = Connectivity();

  static final StreamController<FastNetworkStatus> _controller =
      StreamController<FastNetworkStatus>.broadcast();

  static FastNetworkStatus _currentStatus = FastNetworkStatus.none;

  /// 当前网络状态。
  static FastNetworkStatus get currentStatus => _currentStatus;

  /// 网络状态变化流，订阅后可以实时感知网络切换。
  ///
  /// 示例：
  /// ```dart
  /// FastConnectivity.onStatusChanged.listen((status) {
  ///   FastLog.d('network changed: $status', libPrefix: 'NET');
  /// });
  /// ```
  static Stream<FastNetworkStatus> get onStatusChanged => _controller.stream;

  static StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// 初始化网络监听，在 App 启动时调用一次即可。
  static Future<void> init() async {
    // 先获取一次当前状态
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);

    // 订阅后续变更
    _subscription?.cancel();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  /// 释放监听（例如 App 退出或不再需要监听时）。
  static Future<void> dispose() async {
    await _subscription?.cancel();
    await _controller.close();
  }

  static void _updateStatus(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      _setStatus(FastNetworkStatus.none);
      return;
    }

    // 取第一个非 none 的结果作为当前主要网络类型
    final primary = results.firstWhere(
      (e) => e != ConnectivityResult.none,
      orElse: () => ConnectivityResult.none,
    );

    final status = _mapResult(primary);
    _setStatus(status);
  }

  static void _setStatus(FastNetworkStatus status) {
    if (status == _currentStatus) {
      return;
    }
    _currentStatus = status;
    if (!_controller.isClosed) {
      _controller.add(status);
    }
  }

  static FastNetworkStatus _mapResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.none:
        return FastNetworkStatus.none;
      case ConnectivityResult.wifi:
        return FastNetworkStatus.wifi;
      case ConnectivityResult.mobile:
        return FastNetworkStatus.mobile;
      case ConnectivityResult.ethernet:
        return FastNetworkStatus.ethernet;
      case ConnectivityResult.vpn:
        return FastNetworkStatus.vpn;
      case ConnectivityResult.bluetooth:
        return FastNetworkStatus.bluetooth;
      case ConnectivityResult.other:
        return FastNetworkStatus.other;
    }
  }
}

