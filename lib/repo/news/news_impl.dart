part of 'news_repo.dart';

class NewsImpl extends NewsRepo {
  final NewsService service = NewsService();

  @override
  Future<dynamic> requestNewsList(int page) async {
    final res =
        await service.requestLatestNewsList(page) as Map<String, dynamic>;
    return (res['data'] as Map<String, dynamic>)['rows'];
  }

  @override
  Future<List<dynamic>> searchNewsList(String query) async {
    final res = await service.searchNewsList(query) as Map<String, dynamic>;
    return List<dynamic>.from(
      ((res['data'] as Map<String, dynamic>)['news']
              as Map<String, dynamic>)['value']
          as List<dynamic>,
    );
  }

  @override
  Future<dynamic> searchStockNewsList({
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
    return ((res.data as Map<String, dynamic>)['data']
        as Map<String, dynamic>)['rows'];
  }
}
