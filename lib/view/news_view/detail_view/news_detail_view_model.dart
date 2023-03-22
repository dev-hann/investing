import 'package:investing/controller/news_controller.dart';
import 'package:investing/model/news.dart';
import 'package:investing/view/view.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class NewsDetailViewModel extends ViewModel<NewsController> {
  NewsDetailViewModel(this.news);
  final News news;

  String get titleText => news.title;
  String bodyHtml = "";
  @override
  Future init() async {
    final url = news.articleDetailURL;
    final res = await http.get(Uri.parse(url));
    final doc = parse(res.body);
    final bodyContents = doc.getElementsByClassName("body__content").first;
    bodyHtml = bodyContents.innerHtml;
    return super.init();
  }
}
