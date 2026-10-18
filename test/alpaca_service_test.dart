import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:investing/data/service/alpaca_service.dart';

/// The gitignored local config file — same one the app bundles as an asset.
final File _configFile = File('assets/config/alpaca.json');

void main() {
  test('isConfigured reflects provided credentials', () {
    expect(AlpacaService(key: 'k', secret: 's').isConfigured, isTrue);
    expect(AlpacaService().isConfigured, isFalse);
    expect(AlpacaService(key: 'k').isConfigured, isFalse);
    expect(AlpacaService(key: '', secret: '').isConfigured, isFalse);
  });

  final hasConfig = _configFile.existsSync();
  test(
    'requestPrevCloses returns previous closes (live)',
    () async {
      final map =
          jsonDecode(_configFile.readAsStringSync()) as Map<String, dynamic>;
      final service = AlpacaService(
        key: map['key'] as String? ?? '',
        secret: map['secret'] as String? ?? '',
      );
      final closes = await service.requestPrevCloses(['AAPL', 'MSFT']);
      expect(closes.keys, containsAll(['AAPL', 'MSFT']));
      expect(closes['AAPL'], isPositive);
      expect(closes['MSFT'], isPositive);
    },
    skip: hasConfig ? false : 'assets/config/alpaca.json not present',
    timeout: const Timeout(Duration(seconds: 30)),
  );
}
