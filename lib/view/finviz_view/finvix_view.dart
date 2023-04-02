import 'package:flutter/material.dart';
import 'package:investing/controller/finviz_controller.dart';
import 'package:investing/view/finviz_view/finvix_view_model.dart';
import 'package:investing/view/view.dart';

class FinVizView extends View<FinVizViewModel, FinVizController> {
  FinVizView({super.key}) : super(viewModel: FinVizViewModel());

  @override
  Widget body() {
    return Image.network(viewModel.finViz.imageURL);
  }
}
