library fast_utils;

import 'src/sp_utils.dart';
import 'src/fast_log.dart';
import 'src/fast_app_info.dart';
import 'src/fast_connectivity.dart';

export 'src/sp_utils.dart';
export 'src/fast_log.dart';
export 'src/fast_app_info.dart';
export 'src/fast_connectivity.dart';

class FastUtils {
  /// 一次性初始化 fast_utils 相关能力。
  ///
  /// 内部会依次初始化：
  /// - SharedPreferences（[SpUtils]）
  /// - 应用 & 设备信息（[FastAppInfo]）
  /// - 网络监听（[FastConnectivity]）
  static Future<void> init() async {
    await SpUtils.init();
    await FastAppInfo.init();
    await FastConnectivity.init();
    FastLog.init();
  }
}
