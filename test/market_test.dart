import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:investing/controller/market_controller.dart';
import 'package:investing/model/quote.dart';
import 'package:investing/repo/market/market_repo.dart';
import 'package:investing/use_case/market_use_case.dart';

class _FakeMarketRepo extends MarketRepo {
  _FakeMarketRepo({
    this.cachedPercent = const {},
    this.fallbackPercent = const {},
  });

  final Map<String, double> cachedPercent;
  final Map<String, double> fallbackPercent;
  Map<String, double>? saved;

  @override
  Map<String, double> loadPercentData() => cachedPercent;

  @override
  Future<dynamic> requestMarketData() async => [];

  @override
  Future<dynamic> requestMarketPercentData() async => fallbackPercent;

  @override
  bool get isRealTimeConfigured => false;

  @override
  Future<void> savePercentData(Map<String, double> data) async {
    saved = data;
  }

  @override
  Future<dynamic> requestChartData(List<String> symbolList) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> requestMarketStatus() {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, double>> requestPrevCloses(List<String> symbols) {
    throw UnimplementedError();
  }

  @override
  Stream<Quote> subscribeQuoteStream(List<String> symbols) {
    throw UnimplementedError();
  }
}

void main() {
  test('percentChange computes against the previous close', () {
    expect(percentChange(price: 110, base: 100), closeTo(10.0, 1e-9));
    expect(percentChange(price: 90, base: 100), closeTo(-10.0, 1e-9));
    expect(percentChange(price: 100, base: 100), 0.0);
  });

  group('Quote.tryFromMap', () {
    test('uses the mid of bid and ask', () {
      final quote = Quote.tryFromMap(const {
        'S': 'AAPL',
        'ap': 110.0,
        'bp': 100.0,
      });
      expect(quote?.symbol, 'AAPL');
      expect(quote?.price, 105.0);
    });

    test('falls back to a single side', () {
      expect(Quote.tryFromMap(const {'S': 'AAPL', 'ap': 110.0})?.price, 110.0);
      expect(Quote.tryFromMap(const {'S': 'AAPL', 'bp': 100.0})?.price, 100.0);
    });

    test('rejects payloads without symbol or price', () {
      expect(Quote.tryFromMap(const {'ap': 110.0}), isNull);
      expect(Quote.tryFromMap(const {'S': 'AAPL'}), isNull);
    });
  });

  group('MarketController fallback path', () {
    test(
      'loads cached percents and keeps them when fallback is empty',
      () async {
        final container = ProviderContainer(
          overrides: [
            marketRepoProvider.overrideWithValue(
              _FakeMarketRepo(cachedPercent: {'MSFT': -0.5}),
            ),
          ],
        );
        addTearDown(container.dispose);

        container.read(marketControllerProvider);
        await Future<void>.delayed(Duration.zero);

        expect(container.read(marketControllerProvider).marketPercentData, {
          'MSFT': -0.5,
        });
      },
    );

    test('replaces the map with fresh data and persists it', () async {
      final repo = _FakeMarketRepo(fallbackPercent: {'AAPL': 1.5});
      final container = ProviderContainer(
        overrides: [marketRepoProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      container.read(marketControllerProvider);
      await Future<void>.delayed(Duration.zero);

      expect(container.read(marketControllerProvider).marketPercentData, {
        'AAPL': 1.5,
      });
      expect(repo.saved, {'AAPL': 1.5});
    });
  });
}
