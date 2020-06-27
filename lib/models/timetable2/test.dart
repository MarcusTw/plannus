import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plannusandroidversion/messages/constants.dart';
import 'package:plannusandroidversion/models/timetable/activity.dart';
import 'package:plannusandroidversion/models/timetable/timetable.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';
import 'weekly_event.dart';

// ignore: unused_import
//import 'positioning_demo.dart';
//import 'utils.dart';

void main() async {
//  setTargetPlatformForDesktop();

  WidgetsFlutterBinding.ensureInitialized();
  await TimeMachine.initialize({'rootBundle': rootBundle});
  runApp(MaterialApp(home: TimetableExample()));
}

class TimetableExample extends StatefulWidget {
  @override
  _TimetableExampleState createState() => _TimetableExampleState();
}

class _TimetableExampleState extends State<TimetableExample> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TimetableController<WeeklyEvent> _controller;

  List<WeeklyEvent> convert(TimeTable timetable) {
    final now = DateTime.now();
    final today = now.weekday;
    List<WeeklyEvent> result = new List<WeeklyEvent>();
    for (int i = 0; i < 7; i ++) {
      List<Activity> daySchedule = timetable.timetable[i].ds;
      for (int j = 0; j < 12; j++) {
        Activity a = daySchedule[j];
        if (a.name != 'No Activity') {
          WeeklyEvent we = WeeklyEvent(title: a.name,
              id: i.toString() + ',' + j.toString(),
              day: i+1,
              isImportant: a.isImportant,
              start: LocalDateTime(
                  now.year, now.month, now.day - (today - (i + 1)),
                  Constants.allTimings[j] ~/ 100, 00, 00),
              end: LocalDateTime(
                  now.year, now.month, now.day - (today - (i + 1)),
                  1 + (Constants.allTimings[j] ~/ 100), 00, 00)
          );
          result.add(we);
        }
      }
    }
    return result;
  }

  @override
  void initState() {
    super.initState();

//    _controller = TimetableController(
////       A basic EventProvider containing a single event:
//       eventProvider: EventProvider.list([
//         BasicEvent(
//           id: 0,
//           title: 'My Event',
//           color: Colors.blue,
//           start: LocalDate.today().at(LocalTime(13, 0, 0)),
//           end: LocalDate.today().at(LocalTime(15, 0, 0)),
//         ),
//         BasicEvent(
//             id: 1,
//             title: 'Prev Event in next index',
//             color: Colors.red,
//             start: LocalDate.today().at(LocalTime(10,0,0)),
//             end: LocalDate.today().at(LocalTime(11,0,0))
//         ),
//         BasicEvent(
//             id: 2,
//             title: 'Next Event in next index',
//             color: Colors.red,
//             start: LocalDate.today().at(LocalTime(17,0,0)),
//             end: LocalDate.today().at(LocalTime(19,0,0))
//         ),
//         BasicEvent(
//             id: 3,
//             title: 'Test3',
//             color: Colors.green,
//             start: LocalDate.today().at(LocalTime(15,0,0)),
//             end: LocalDate.today().at(LocalTime(16,0,0))
//         ),
//       ]),
//
//       Or even this short example using a Stream:
//       eventProvider: EventProvider.stream(
//         eventGetter: (range) => Stream.periodic(
//           Duration(milliseconds: 16),
//           (i) {
//             final start =
//                 LocalDate.today().atMidnight() + Period(minutes: i * 2);
//             return [
//               BasicEvent(
//                 id: 0,
//                 title: 'Event',
//                 color: Colors.blue,
//                 start: start,
//                 end: start + Period(hours: 5),
//               ),
//             ];
//           },
//         ),
//       ),
//
//       Other (optional) parameters:
//      initialTimeRange: InitialTimeRange.range(
//        startTime: LocalTime(8, 0, 0),
//        endTime: LocalTime(20, 0, 0),
//      ),
//      initialDate: LocalDate.today(),
//      visibleRange: VisibleRange.days(5),
//      firstDayOfWeek: DayOfWeek.monday,
//    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _controller = TimetableController(
      eventProvider: EventProvider.list(convert(Provider.of<User>(context).timetable)),
      initialTimeRange: InitialTimeRange.range(
        startTime: LocalTime(8, 0, 0),
        endTime: LocalTime(20, 0, 0),
      ),
      initialDate: LocalDate.today(),
      visibleRange: VisibleRange.days(5),
      firstDayOfWeek: DayOfWeek.monday,
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Timetable example'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.today),
            onPressed: () => _controller.animateToToday(),
            tooltip: 'Jump to today',
          ),
        ],
      ),
      body: Timetable<WeeklyEvent>(
        controller: _controller,
        onEventBackgroundTap: (start, isAllDay) {
          _showSnackBar('Background tapped $start is all day event $isAllDay');
        },
        eventBuilder: (event) {
          return WeeklyEventWidget(
            event,
          );
        },
//        allDayEventBuilder: (context, event, info) => BasicAllDayEventWidget(
//          event,
//          info: info,
//          onTap: () => _showSnackBar('All-day event $event tapped'),
//        ),
      ),
    );
  }

  void _showSnackBar(String content) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(content),
    ));
  }
}