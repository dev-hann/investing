part of calendar_event;

class EconomicEvent extends CalendarEvent {
  const EconomicEvent({
    required this.gmt,
    required this.country,
    required this.eventName,
    required this.actual,
    required this.consensus,
    required this.previous,
    required this.description,
  }) : super(CalendarEventType.economics);
  final String gmt;
  final String country;
  final String eventName;
  final String actual;
  final String consensus;
  final String previous;
  final String description;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gmt': gmt,
      'country': country,
      'eventName': eventName,
      'actual': actual,
      'consensus': consensus,
      'previous': previous,
      'description': description,
    };
  }

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
}
