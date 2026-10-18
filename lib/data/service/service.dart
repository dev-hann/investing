library;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

part './news_service.dart';
part './stock_service.dart';

abstract class IVService {
  final _dio = Dio();

  Future<Response> post(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) {
    return _dio.post(
      url,
      data: data,
      options: Options(
        headers: headers,
      ),
    );
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? query,
  }) async {
    try {
      return await _dio.get(
        url,
        queryParameters: query,
      );
    } catch (e) {
      if (e is DioException) {
        debugPrint("URL: ${e.requestOptions.uri}");
      }
      rethrow;
    }
  }
}
