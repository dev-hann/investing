import 'package:investing/controller/calendar_controller.dart';
import 'package:investing/model/calendar/calendar_event.dart';
import 'package:investing/view/view.dart';

class CalendarViewModel extends ViewModel<CalendarController> {
  final List<CalendarEventType> eventTypeList = CalendarEventType.values;
}
