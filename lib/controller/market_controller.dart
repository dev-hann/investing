import 'package:get/get.dart';
import 'package:investing/controller/controller.dart';
import 'package:investing/model/market.dart';
import 'package:investing/use_case/market_use_case.dart';

class MarketController extends Controller<MarketUseCase> {
  MarketController(super.useCase);

  static MarketController find() => Get.find<MarketController>();
  final RxList<MarketData> marketDataList = RxList();

  @override
  void onReady() {
    refreshMarketData();
    super.onReady();
  }

  Future refreshMarketData() async {
    final data = await useCase.requestMarketData();
    marketDataList(data);
  }
}
