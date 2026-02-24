import 'package:logger/logger.dart';

/// Simple global logger wrapper.
class FastLog {
  FastLog._internal(this._logger, this._prefix);

  static FastLog? _instance;
  final Logger _logger;
  final String _prefix;

  /// 全局日志前缀（例如环境、业务标识等），可在初始化时或运行时设置。
  static String get prefix => I._prefix;

  /// 运行时动态修改日志前缀。
  static set prefix(String value) {
    final instance = _instance;
    if (instance == null) {
      throw StateError(
        'FastLog is not initialized. Call FastLog.init() in main() first.',
      );
    }
    _instance = FastLog._internal(instance._logger, value);
  }

  /// Initialize global logger with optional custom [Logger].
  ///
  /// [prefix] 用来统一给每条日志增加一个前缀，例如：
  /// - 'DEV'
  /// - '[MyApp]'
  /// - 'userId=xxx'
  static void init({Logger? logger, String prefix = ''}) {
    _instance = FastLog._internal(
      logger ??
          Logger(
            printer: PrettyPrinter(
              methodCount: 2,
              errorMethodCount: 8,
              lineLength: 120,
              colors: true,
              printEmojis: true,
              printTime: false,
            ),
          ),
      prefix,
    );
  }

  static FastLog get I {
    final instance = _instance;
    if (instance == null) {
      throw StateError(
        'FastLog is not initialized. Call FastLog.init() in main() first.',
      );
    }
    return instance;
  }

  Logger get raw => _logger;

  static String _buildMessage(
    dynamic message, {
    String? libPrefix,
  }) {
    final parts = <String>[];

    final globalPrefix = I._prefix;
    if (globalPrefix.isNotEmpty) {
      parts.add(globalPrefix);
    }

    if (libPrefix != null && libPrefix.isNotEmpty) {
      parts.add(libPrefix);
    }

    final msg = message?.toString() ?? '';

    if (parts.isEmpty) {
      return msg;
    }

    // 形如 "[GLOBAL][NET] xxx"
    return '[${parts.join('][')}] $msg';
  }

  /// 默认日志输出。
  ///
  /// [libPrefix] 用于区分不同库 / 模块的日志前缀，例如：
  /// `FastLog.d('request start', libPrefix: 'NET');`
  static void d(
    dynamic message, {
    String? libPrefix,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    I._logger.d(
      _buildMessage(message, libPrefix: libPrefix),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void i(
    dynamic message, {
    String? libPrefix,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    I._logger.i(
      _buildMessage(message, libPrefix: libPrefix),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void w(
    dynamic message, {
    String? libPrefix,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    I._logger.w(
      _buildMessage(message, libPrefix: libPrefix),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void e(
    dynamic message, {
    String? libPrefix,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    I._logger.e(
      _buildMessage(message, libPrefix: libPrefix),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void t(
    dynamic message, {
    String? libPrefix,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    I._logger.t(
      _buildMessage(message, libPrefix: libPrefix),
      error: error,
      stackTrace: stackTrace,
    );
  }
}
