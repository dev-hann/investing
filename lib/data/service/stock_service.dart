import 'package:dividends_manager/data/service/service.dart';

const _searchURL = "https://api.nasdaq.com/api/search/site";

class StockService extends Service {
  Future search(String query) async {
    final res = await get(
      _searchURL,
      {
        "query": query,
      },
    );
    return res.data;
  }
}
