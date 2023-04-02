import 'package:investing/controller/controller.dart';
import 'package:investing/data/service/finviz_service.dart';
import 'package:investing/model/finviz.dart';

class FinVizController extends Controller {
  final FinVizService service = FinVizService();
  FinViz finViz = FinViz.empty;

  @override
  void onReady() async {
    final res = await service.requestFinViz();
    finViz = FinViz.fromMap(res);
    super.onReady();
  }
}
