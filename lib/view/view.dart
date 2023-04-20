library view;

import 'dart:async';

import 'package:investing/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/widget/loading_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
part './view_model.dart';

abstract class View<T extends ViewModel, S extends Controller>
    extends StatelessWidget {
  const View({
    super.key,
    required this.viewModel,
  });

  final T viewModel;

  Widget body();
  Widget _loadingView() {
    return const CircularProgressIndicator();
  }

  Widget _overlayLoadingView() {
    if (!viewModel.isOverlayLoading) {
      return const SizedBox();
    }
    return const IVLoadingWidget();
  }

  @mustCallSuper
  void init() {
    viewModel._init();
  }

  void didUpdateWidget() async {}

  void dispose() {
    viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetBuilder<S>(
        key: key ?? ValueKey(viewModel.viewID),
        id: viewModel.viewID,
        initState: (state) {
          init();
        },
        didUpdateWidget: (oldWidget, state) {
          didUpdateWidget();
        },
        dispose: (state) {
          dispose();
        },
        builder: (controller) {
          if (viewModel.isLoading) {
            return Center(
              child: _loadingView(),
            );
          }
          return Stack(
            children: [
              body(),
              _overlayLoadingView(),
            ],
          );
        },
      ),
    );
  }
}
