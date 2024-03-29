part of service;
// 4006 markets
// 3996 Companies
// 4226 Crypto
// 4001 tech
// 3991 personal Finance
// 4026 financial Advance
// ex) https://api.nasdaq.com/api/news/topic/article?q=field_primary_topic:4226&limit=3
// https://api.nasdaq.com/api/news/topic/latestnews?offset=0&limit=10

class NewsService extends IVService {
  Future requestLatestNewsList(
    int page, {
    int stride = 20,
  }) async {
    final begin = (page - 1) * stride;
    final end = page * stride;
    const url = "https://api.nasdaq.com/api/news/topic/latestnews";
    final res = await get(
      url,
      query: {
        "offset": begin,
        "limit": end,
      },
    );
    return res.data;
  }

  Future searchNewsList(String query) async {
    const url = "https://api.nasdaq.com/api/search/site";
    final res = await get(
      url,
      query: {
        "query": query,
      },
    );
    return res.data;
  }

  Future<Response> searchStockNewsList({
    required String symbol,
    required String asset,
    required int page,
    required int stride,
  }) async {
    const url = "https://api.nasdaq.com/api/news/topic/articlebysymbol";
    return get(
      url,
      query: {
        "q": "$symbol|$asset",
        "offset": (page - 1) * stride,
        "limit": stride,
        "fallback": false,
      },
    );
  }
}
