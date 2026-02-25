import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Toast 相关工具。
class FastToast {
  FastToast._();

  /// 显示一条 Toast 文本。
  ///
  /// 依赖 fluttertoast，无需 BuildContext。
  static Future<bool?> show(
    String message, {
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.CENTER,
    double fontSize = 16.0,
  }) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      fontSize: fontSize,
    );
  }
}

/// 全局 Loading 相关工具。
///
/// 封装 flutter_easyloading：
/// - 需要在 App 顶层配置：`builder: EasyLoading.init()`
class FastLoading {
  FastLoading._();

  /// 显示加载中。
  ///
  /// [status] 为可选文本，例如 “加载中...”
  static void show({
    String? status,
    Widget? indicator,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
  }) {
    EasyLoading.show(
      status: status,
      indicator: indicator,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
    );
  }

  /// 显示成功提示并自动消失。
  static void showSuccess(
    String message, {
    Duration? duration,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
  }) {
    EasyLoading.showSuccess(
      message,
      duration: duration,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
    );
  }

  /// 显示失败提示并自动消失。
  static void showError(
    String message, {
    Duration? duration,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
  }) {
    EasyLoading.showError(
      message,
      duration: duration,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
    );
  }

  /// 关闭当前 Loading。
  static void dismiss() {
    EasyLoading.dismiss();
  }
}
