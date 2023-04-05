part of calendar_event;

class EconomicEvent extends CalendarEvent {
  EconomicEvent({
    required this.gmt,
    required String country,
    required this.eventName,
    required this.actual,
    required this.consensus,
    required this.previous,
    required this.description,
  })  : country = Country.fromName(country),
        super(CalendarEventType.economics);
  final String gmt;
  final Country country;
  final String eventName;
  final String actual;
  final String consensus;
  final String previous;
  final String description;

  factory EconomicEvent.fromMap(Map<String, dynamic> map) {
    return EconomicEvent(
      gmt: map['gmt'] as String,
      country: map['country'] as String,
      eventName: map['eventName'] as String,
      actual: map['actual'] as String,
      consensus: map['consensus'] as String,
      previous: map['previous'] as String,
      description: map['description'] as String,
    );
  }

  @override
  List<Object?> get props => [
        type,
        gmt,
        country,
        eventName,
        actual,
        consensus,
        previous,
        description,
      ];
}
