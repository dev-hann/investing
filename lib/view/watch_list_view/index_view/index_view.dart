import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/const/color.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/view/view.dart';
import 'package:investing/view/watch_list_view/index_view/index_view_model.dart';
import 'package:investing/widget/title_widget.dart';

class IndexView extends View<IndexViewModel, StockController> {
  IndexView({super.key}) : super(viewModel: IndexViewModel());

  double get size => Get.width / 3.5;

  Widget item() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: IVColor.blueGrey,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: SizedBox.square(
        dimension: size,
      ),
    );
  }

  @override
  Widget body() {
    return TitleWidget(
      title: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text("Index"),
      ),
      child: SizedBox(
        height: size,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: 10,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) {
            return const SizedBox(width: 8.0);
          },
          itemBuilder: (context, index) {
            return item();
          },
        ),
      ),
    );
  }
}
