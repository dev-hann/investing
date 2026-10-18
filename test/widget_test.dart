import 'package:flutter_test/flutter_test.dart';

import 'package:investing/model/chart.dart';
import 'package:investing/model/market.dart';

void main() {
  test('IVChart parses and compares by dateTime', () {
    final chart = IVChart.fromMap(const {
      'x': 100,
      'y': 2.5,
    });
    expect(chart.dateTime, 100);
    expect(chart.value, 2.5);
    expect(chart.compareTo(IVChart(200, 1.0)), isNegative);
  });

  test('MarketData parses nested sectors and items', () {
    final market = MarketData.fromMap(const {
      'name': 'Technology',
      'children': [
        {
          'name': 'AAPL',
          'children': [
            {'name': 'AAPL', 'description': 'Apple Inc.', 'value': 3000},
          ],
        },
      ],
    });
    expect(market.name, 'Technology');
    expect(market.childeren.single.name, 'AAPL');
    expect(market.childeren.single.sumValue, 3000);
    expect(market.sumValue, 3000);
  });
}
