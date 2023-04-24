part of news_repo;

class NewsImpl extends NewsRepo {
  final NewsService newsService = NewsService();

  @override
  Future requestNewsList(int page) async {
    final res = await newsService.requestLatestNewsList(page);
    return res["data"]["rows"];
  }
}
