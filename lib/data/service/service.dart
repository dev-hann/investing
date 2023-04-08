library service;

import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

part './news_service.dart';
part './stock_service.dart';

const _searchURL = "https://api.nasdaq.com/api/search/site";

enum SearchType {
  stock,
  news,
}

extension SearchTypeExtension on SearchType {
  String toLabel() {
    switch (this) {
      case SearchType.stock:
        return "symbol";
      case SearchType.news:
        return "news";
    }
  }
}

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

  Future<List> _search(
    SearchType type, {
    required String query,
  }) async {
    final res = await get(
      _searchURL,
      query: {
        "query": query,
      },
    );
    return List.from(res.data["data"][type.toLabel()]["value"]);
  }
}
