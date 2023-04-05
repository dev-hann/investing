import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:investing/controller/finviz_controller.dart';
import 'package:investing/view/finviz_view/finvix_view_model.dart';
import 'package:investing/view/view.dart';

class FinVizView extends View<FinVizViewModel, FinVizController> {
  FinVizView({super.key}) : super(viewModel: FinVizViewModel());

  AppBar appBar() {
    return AppBar(
      title: const Text("FinViz"),
    );
  }

  @override
  Widget body() {
    return Scaffold(
      appBar: appBar(),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxHeight;
            return RotatedBox(
              quarterTurns: 1,
              child: SizedBox(
                width: width,
                height: width / viewModel.screenRatio,
                child: InAppWebView(
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      contentBlockers: viewModel.contentBlockers,
                    ),
                  ),
                  initialUrlRequest: URLRequest(
                    url: viewModel.uri,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
