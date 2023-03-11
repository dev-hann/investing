library view;

import 'package:dividends_manager/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return ColoredBox(
      color: Colors.black.withOpacity(0.4),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetBuilder<S>(
        key: UniqueKey(),
        initState: (state) {
          viewModel._init();
        },
        dispose: (state) {
          viewModel.dispose();
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
