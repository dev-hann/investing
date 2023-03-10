import 'package:dividends_manager/model/stock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class StockCard extends StatelessWidget {
  const StockCard({
    super.key,
    required this.stock,
  });
  final Stock stock;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Slidable(
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {},
              backgroundColor: const Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
            ),
            SlidableAction(
              onPressed: (context) {},
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: ListTile(
          title: Text(stock.name),
          subtitle: Text(stock.tickerID),
        ),
      ),
    );
  }
}
