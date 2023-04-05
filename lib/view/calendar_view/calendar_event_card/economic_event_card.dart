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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: IntrinsicHeight(
        child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(event.gmt),
              Text(event.country.icon()),
            ],
          ),
          title: Text(event.eventName),
          subtitle: Text(
              "Act: ${removeNbsp(event.actual)} | Cons: ${event.consensus} | Prev: ${event.previous}"),
        ),
      ),
    );
  }
}
