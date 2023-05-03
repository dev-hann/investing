import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/const/color.dart';
import 'package:investing/controller/market_controller.dart';
import 'package:investing/model/market_status.dart';

class MarketStatusWidget extends StatelessWidget {
  const MarketStatusWidget({
    super.key,
  });

  Widget statusIcon({
    required bool isOpned,
  }) {
    return Icon(
      Icons.online_prediction,
      color: isOpned ? IVColor.orange : IVColor.grey,
    );
  }

  Widget statusText({
    required bool isOpned,
    required MarketStatusType type,
  }) {
    String text = "Closed";
    if (isOpned) {
      switch (type) {
        case MarketStatusType.pre:
          text = "Pre";
          break;
        case MarketStatusType.regular:
          text = "Open";
          break;
        case MarketStatusType.after:
          text = "After";
          break;
      }
    }
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: Theme.of(context).textTheme.labelSmall,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = MarketController.find();
    return Obx(() {
      final status = controller.marketStatus.value;
      if (status == null) {
        return const SizedBox();
      }
      final isOpened = status.isOpened;
      final type = status.type;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          statusIcon(
            isOpned: isOpened,
          ),
          statusText(
            isOpned: isOpened,
            type: type,
          ),
        ],
      );
    });
  }
}
