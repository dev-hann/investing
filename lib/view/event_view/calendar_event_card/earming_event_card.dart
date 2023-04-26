import 'package:flutter/material.dart';
import 'package:investing/model/calendar/calendar_event.dart';

class EarningEventCard extends StatelessWidget {
  const EarningEventCard({
    super.key,
    required this.event,
  });
  final EarningEvent event;

  String removeNbsp(String data) {
    return data.replaceAll("&nbsp;", "-");
  }

  Widget titleWidget() {
    return Text(event.name);
  }

  Widget subtitleWidget() {
    return Text(event.symbol);
  }

  Widget trailingWidget() {
    return Text(event.time);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: titleWidget(),
          subtitle: subtitleWidget(),
          // trailing: trailingWidget(),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
