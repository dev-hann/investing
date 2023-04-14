library service;

import 'package:dio/dio.dart';

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
  }) {
    return _dio.get(
      url,
      queryParameters: query,
    );
  }
}
