part of 'news_repo.dart';

class NewsImpl extends NewsRepo {
  final NewsService service = NewsService();
  final IVDataBase cacheDB = IVDataBase('NewsCache');

  @override
  Future<void> init() async {
    await cacheDB.init();
    return super.init();
  }

  /// Last-known-good first page, shown when the network fails.
  List<News>? _loadCachedFirstPage() {
    final data = cacheDB.read('first_page');
    if (data is List && data.isNotEmpty) {
      try {
        return List<Map<String, dynamic>>.from(data).map(News.latest).toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<List<News>> requestNewsList(int page) async {
    try {
      final res =
          await service.requestLatestNewsList(page) as Map<String, dynamic>;
      final rows =
          ((res['data'] as Map<String, dynamic>)['rows'] as List<dynamic>)
              .cast<Map<String, dynamic>>();
      if (page == 1) {
        await cacheDB.put(key: 'first_page', value: rows);
      }
      return rows.map(News.latest).toList();
    } catch (e) {
      if (page == 1) {
        final cached = _loadCachedFirstPage();
        if (cached != null) {
          return cached;
        }
      }
      rethrow;
    }
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
