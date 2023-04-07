import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:investing/view/finviz_view/finvix_view_model.dart';

class FinVizView extends StatefulWidget {
  const FinVizView({super.key});

  @override
  State<FinVizView> createState() => _FinVizViewState();
}

class _FinVizViewState extends State<FinVizView>
    with AutomaticKeepAliveClientMixin {
  final viewModel = FinVizViewModel();
  late Widget keepAlive;

  @override
  void initState() {
    super.initState();
    keepAlive = body();
  }

  AppBar appBar() {
    return AppBar(
      title: const Text("FinViz"),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return keepAlive;
  }

  @override
  bool get wantKeepAlive => true;
}
