import 'package:dio/dio.dart';

abstract class Service {
  final _dio = Dio();

  Future post(String url, dynamic data) {
    return _dio.post(
      url,
    );
  }

  Future<Response> get(String url, Map<String, dynamic> query) {
    return _dio.get(url, queryParameters: query);
  }
}
