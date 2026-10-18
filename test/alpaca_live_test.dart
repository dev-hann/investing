import 'package:flutter_test/flutter_test.dart';
import 'package:investing/data/service/alpaca_service.dart';

/// Live smoke test against the real Alpaca API — runs only when credentials
/// are injected via `--dart-define`, skipped otherwise (e.g. in CI):
///
/// ```sh
/// flutter test --dart-define=ALPACA_KEY=... --dart-define=ALPACA_SECRET=... \
///   test/alpaca_live_test.dart
/// ```
void main() {
  final configured = AlpacaService().isConfigured;
  test(
    'requestPrevCloses returns previous closes (live)',
    () async {
      final service = AlpacaService();
      final closes = await service.requestPrevCloses(['AAPL', 'MSFT']);
      expect(closes.keys, containsAll(['AAPL', 'MSFT']));
      expect(closes['AAPL'], isPositive);
      expect(closes['MSFT'], isPositive);
    },
    skip: configured
        ? false
        : 'Alpaca credentials not provided (--dart-define)',
    timeout: const Timeout(Duration(seconds: 30)),
  );
}
