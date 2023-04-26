import 'package:investing/model/market.dart';
import 'package:investing/repo/market/market_repo.dart';
import 'package:investing/use_case/use_case.dart';

class MarketUseCase extends UseCase<MarketRepo> {
  MarketUseCase(super.repo);

  Future<List<MarketData>> requestMarketData() async {
    final list = List.from(await repo.requestMarketData());
    return list.map((e) => MarketData.fromMap(e)).toList();
  }
}
