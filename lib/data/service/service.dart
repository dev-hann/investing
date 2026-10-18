library;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

part './news_service.dart';
part './stock_service.dart';

abstract class IVService {
  IVService() {
    _dio.interceptors.add(_statusInterceptor);
  }

  final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: <String, dynamic>{
        'Accept': 'application/json, text/plain, */*',
        'User-Agent':
            'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 '
            '(KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36',
      },
    ),
  );

  /// Nasdaq wraps failures as HTTP 200 + `{status: {rCode: != 200}}` —
  /// surface those as errors so repos can fall back to cached data.
  final _statusInterceptor = InterceptorsWrapper(
    onResponse: (response, handler) {
      final host = response.requestOptions.uri.host;
      final data = response.data;
      if (host == 'api.nasdaq.com' && data is Map<String, dynamic>) {
        final status = data['status'];
        if (status is Map<String, dynamic>) {
          final rCode = status['rCode'];
          if (rCode is int && rCode != 200) {
            if (kDebugMode) {
              debugPrint(
                'IVService: ${response.requestOptions.uri} '
                'rCode=$rCode ${status['message'] ?? ''}',
              );
            }
            handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                type: DioExceptionType.badResponse,
                message: 'Nasdaq API error rCode=$rCode',
              ),
            );
            return;
          }
        }
      }
      handler.next(response);
    },
  );

  Future<Response<dynamic>> post(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) {
    return _dio.post(
      url,
      data: data,
      options: Options(headers: headers),
    );
  }

  Future<Response<dynamic>> get(
    String url, {
    Map<String, dynamic>? query,
  }) async {
    try {
      return await _dio.get(url, queryParameters: query);
    } catch (e) {
      if (e is DioException && kDebugMode) {
        debugPrint('URL: ${e.requestOptions.uri}');
      }
      rethrow;
    }
  }
}
