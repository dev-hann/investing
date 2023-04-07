import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:investing/model/calendar/calendar_event.dart';

class EconomicEventCard extends StatelessWidget {
  const EconomicEventCard({
    super.key,
    required this.event,
  });
  final EconomicEvent event;

  String removeNbsp(String data) {
    return data.replaceAll("&nbsp;", "-");
  }

  Widget leadingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(event.gmt),
        Text(event.country.icon()),
      ],
    );
  }

  Widget titleWidget() {
    return Text(event.eventName);
  }

  Widget subtitleWidget() {
    return AutoSizeText(
      "Act: ${removeNbsp(event.actual)} | Cons: ${removeNbsp(event.consensus)} | Prev: ${removeNbsp(event.previous)}",
      maxLines: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Builder(
        builder: (context) {
          final desc = event.description;
          if (desc.isEmpty) {
            return ListTile(
              leading: leadingWidget(),
              title: titleWidget(),
              subtitle: subtitleWidget(),
            );
          }
          return Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: leadingWidget(),
              title: titleWidget(),
              subtitle: subtitleWidget(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(desc),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
