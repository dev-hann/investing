import 'package:flutter/material.dart';
import 'package:investing/const/color.dart';
import 'package:investing/model/market_status.dart';

class MarketStatusWidget extends StatelessWidget {
  const MarketStatusWidget({
    super.key,
    required this.status,
  });
  final MarketStatus status;
  bool get isOpned => status.isOpened;
  MarketStatusType get type => status.type;

  Widget statusIcon() {
    return Icon(
      Icons.online_prediction,
      color: isOpned ? IVColor.orange : IVColor.grey,
    );
  }

  Widget statusText() {
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        statusIcon(),
        statusText(),
      ],
    );
  }
}
