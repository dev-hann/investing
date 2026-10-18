import 'dart:convert';

import 'package:flutter/services.dart';

/// Runtime configuration loaded from a gitignored asset,
/// `assets/config/alpaca.json`:
///
/// ```json
/// { "key": "<key-id>", "secret": "<secret>" }
/// ```
///
/// The file is intentionally not committed — see `assets/config/README.md`.
/// When absent (fresh clone, CI), everything stays empty and features that
/// need credentials degrade gracefully.
class IVConfig {
  IVConfig._();

  static const String _assetPath = 'assets/config/alpaca.json';

  static String alpacaKey = '';
  static String alpacaSecret = '';

  static bool get isAlpacaConfigured =>
      alpacaKey.isNotEmpty && alpacaSecret.isNotEmpty;

  /// Call once in `main()` before `runApp`.
  static Future<void> load() async {
    try {
      final raw = await rootBundle.loadString(_assetPath);
      final map = jsonDecode(raw) as Map<String, dynamic>;
      alpacaKey = map['key'] as String? ?? '';
      alpacaSecret = map['secret'] as String? ?? '';
    } catch (_) {
      // No config asset — run with credentials disabled.
    }
  }
}
