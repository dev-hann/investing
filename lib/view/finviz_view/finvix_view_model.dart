import 'package:investing/controller/finviz_controller.dart';
import 'package:investing/model/finviz.dart';
import 'package:investing/view/view.dart';

class FinVizViewModel extends ViewModel<FinVizController> {
  FinViz get finViz => controller.finViz;
}
