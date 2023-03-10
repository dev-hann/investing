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
  Widget loadingView() {
    return const CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetBuilder<S>(
        key: UniqueKey(),
        initState: (state) {
          viewModel._init();
        },
        builder: (controller) {
          if (viewModel.isLoading) {
            return Center(
              child: loadingView(),
            );
          }
          return body();
        },
      ),
    );
  }
}
