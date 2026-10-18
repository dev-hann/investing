part of 'news_repo.dart';

class NewsImpl extends NewsRepo {
  final NewsService service = NewsService();

  @override
  Future<List<News>> requestNewsList(int page) async {
    final res =
        await service.requestLatestNewsList(page) as Map<String, dynamic>;
    final rows =
        ((res['data'] as Map<String, dynamic>)['rows'] as List<dynamic>)
            .cast<Map<String, dynamic>>();
    return rows.map(News.latest).toList();
  }

  @override
  Future<List<News>> searchNewsList(String query) async {
    final res = await service.searchNewsList(query) as Map<String, dynamic>;
    final rows =
        (((res['data'] as Map<String, dynamic>)['news']
                    as Map<String, dynamic>)['value']
                as List<dynamic>)
            .cast<Map<String, dynamic>>();
    return rows.map(News.search).toList();
  }

  @override
  Future<List<News>> searchStockNewsList({
    required String symbol,
    required String asset,
    required int page,
  }) async {
    final res = await service.searchStockNewsList(
      symbol: symbol,
      asset: asset,
      page: page,
      stride: 20,
    );
    final rows =
        (((res.data as Map<String, dynamic>)['data']
                    as Map<String, dynamic>)['rows']
                as List<dynamic>)
            .cast<Map<String, dynamic>>();
    return rows.map(News.latest).toList();
  }
}
