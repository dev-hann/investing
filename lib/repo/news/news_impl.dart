part of news_repo;

class NewsImpl extends NewsRepo {
  final NewsService service = NewsService();

  @override
  Future requestNewsList(int page) async {
    final res = await service.requestLatestNewsList(page);
    return res["data"]["rows"];
  }

  @override
  Future searchNewsList(String query) async {
    final res = await service.searchNewsList(query);
    return res["data"]["rows"];
  }
}
