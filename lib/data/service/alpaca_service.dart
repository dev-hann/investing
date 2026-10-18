import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:investing/data/config.dart';

/// Alpaca market-data client (IEX feed, free tier).
///
/// Credentials come from `assets/config/alpaca.json` (gitignored) via
/// [IVConfig]; tests may inject them through the constructor. Without
/// credentials the service reports [isConfigured] == false and every call
/// degrades to an empty result.
class AlpacaService {
  AlpacaService({String? key, String? secret})
    : key = key ?? IVConfig.alpacaKey,
      secret = secret ?? IVConfig.alpacaSecret,
      _dio = Dio(
        BaseOptions(
          baseUrl: 'https://data.alpaca.markets',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

  final Dio _dio;
  final String key;
  final String secret;

  static const String _wsUrl = 'wss://stream.data.alpaca.markets/v2/iex';

  bool get isConfigured => key.isNotEmpty && secret.isNotEmpty;

  Map<String, String> get _headers => {
    'APCA-API-KEY-ID': key,
    'APCA-API-SECRET-KEY': secret,
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
      socket.add(jsonEncode({'action': 'auth', 'key': key, 'secret': secret}));
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
