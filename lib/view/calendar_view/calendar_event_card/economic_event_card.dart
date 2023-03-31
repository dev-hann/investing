import 'package:flutter/material.dart';
import 'package:investing/model/calendar/calendar_event.dart';
import 'package:investing/model/country.dart';

class EconomicEventCard extends StatelessWidget {
  const EconomicEventCard({
    super.key,
    required this.event,
  });
  final EconomicEvent event;

  Widget countryWidget() {
    final country = Country.fromName(event.country);
    return Text(country.icon());
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
              countryWidget(),
            ],
          ),
          title: Text(event.eventName),
          subtitle: Text(
              "Act: ${event.actual} | Cons: ${event.consensus} | Prev: ${event.previous}"),
        ),
      ),
    );
  }
}
