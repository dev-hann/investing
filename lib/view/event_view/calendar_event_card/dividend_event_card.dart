import 'package:flutter/material.dart';
import 'package:investing/model/calendar/calendar_event.dart';

class DividendEventCard extends StatelessWidget {
  const DividendEventCard({
    super.key,
    required this.event,
  });
  final DividendEvent event;

  String removeNbsp(String data) {
    return data.replaceAll("&nbsp;", "-");
  }

  Widget titleWidget() {
    return Text(
      event.companyName,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget subtitleWidget() {
    return Text(event.symbol);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Builder(
        builder: (context) {
          return Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: titleWidget(),
              subtitle: subtitleWidget(),
              children: [],
            ),
          );
        },
      ),
    );
  }
}
