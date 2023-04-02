import 'package:investing/data/service/service.dart';

class FinVizService extends IVService {
  final url = "https://finviz.com/publish_map_submit.ashx";
  Future<dynamic> requestFinViz() {
    return post(
      url,
      {},
    );
  }
}
