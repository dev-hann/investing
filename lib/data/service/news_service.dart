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

  Future<List> searchNews(String query) async {
    const url = "https://api.nasdaq.com/api/search/site";
    final res = await get(
      url,
      query: {
        "query": query,
      },
    );
    return List.from(res.data["data"]["news"]["value"]);
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
}
