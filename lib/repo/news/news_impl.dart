part of news_repo;

class NewsImpl extends NewsRepo {
  final NewsService newsService = NewsService();

  @override
  Future requestNewsList() {
    // TODO: implement requestNewsList
    throw UnimplementedError();
  }
}
