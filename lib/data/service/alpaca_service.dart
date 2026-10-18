import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Alpaca market-data client (IEX feed, free tier).
///
/// Credentials are injected at compile time — never stored in the repo:
///
/// ```sh
/// flutter run \
///   --dart-define=ALPACA_KEY=<key-id> \
///   --dart-define=ALPACA_SECRET=<secret>
/// ```
///
/// Without both defines the service reports [isConfigured] == false and
/// every call degrades to an empty result.
class AlpacaService {
  AlpacaService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'https://data.alpaca.markets',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

  final Dio _dio;

  static const String _wsUrl = 'wss://stream.data.alpaca.markets/v2/iex';
  static const String _key = String.fromEnvironment('ALPACA_KEY');
  static const String _secret = String.fromEnvironment('ALPACA_SECRET');

  bool get isConfigured => _key.isNotEmpty && _secret.isNotEmpty;

  Map<String, String> get _headers => {
    'APCA-API-KEY-ID': _key,
    'APCA-API-SECRET-KEY': _secret,
  };

  /// Previous daily close per symbol, from IEX snapshots (batched by 200).
  Future<Map<String, double>> requestPrevCloses(List<String> symbols) async {
    final result = <String, double>{};
    for (int i = 0; i < symbols.length; i += 200) {
      final chunk = symbols.sublist(i, min(i + 200, symbols.length));
      final res = await _dio.get<dynamic>(
        '/v2/stocks/snapshots',
        queryParameters: {'symbols': chunk.join(','), 'feed': 'iex'},
        options: Options(headers: _headers),
      );
      final data = res.data;
      if (data is! Map<String, dynamic>) {
        continue;
      }
      data.forEach((symbol, snapshot) {
        if (snapshot is! Map<String, dynamic>) {
          return;
        }
        final bar = snapshot['prevDailyBar'] as Map<String, dynamic>?;
        final close = (bar?['c'] as num?)?.toDouble();
        if (close != null && close > 0) {
          result[symbol] = close;
        }
      });
    }
    return result;
  }

  /// Live quote maps (`T == 'q'` payloads: `S`, `bp`, `ap`, …).
  ///
  /// Reconnects every 5 seconds after a drop; never ends while the app runs.
  Stream<Map<String, dynamic>> subscribeQuotes(List<String> symbols) async* {
    if (!isConfigured || symbols.isEmpty) {
      return;
    }
    while (true) {
      try {
        await for (final quote in _connect(symbols)) {
          yield quote;
        }
      } catch (e) {
        debugPrint('AlpacaService: stream error, reconnecting — $e');
      }
      await Future<void>.delayed(const Duration(seconds: 5));
    }
  }

  Stream<Map<String, dynamic>> _connect(List<String> symbols) async* {
    final socket = await WebSocket.connect(_wsUrl);
    try {
      socket.add(
        jsonEncode({'action': 'auth', 'key': _key, 'secret': _secret}),
      );
      for (int i = 0; i < symbols.length; i += 200) {
        final chunk = symbols.sublist(i, min(i + 200, symbols.length));
        socket.add(jsonEncode({'action': 'subscribe', 'quotes': chunk}));
      }
      await for (final message in socket) {
        final decoded = jsonDecode(message as String);
        if (decoded is! List<dynamic>) {
          continue;
        }
        for (final item in decoded) {
          if (item is! Map<String, dynamic>) {
            continue;
          }
          final type = item['T'];
          if (type == 'q') {
            yield item;
          } else if (type == 'error') {
            debugPrint('AlpacaService: ${item['code']} ${item['msg']}');
          }
        }
      }
    } finally {
      await socket.close();
    }
  }
}
