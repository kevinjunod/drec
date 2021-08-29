import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drec/constants.dart';
import 'package:drec/models/listDoctorModel.dart';
import 'package:drec/providers/schedule.dart';
import 'package:drec/screens/home/client/appointment/listSchedule.dart';
import 'package:drec/screens/home/client/appointment/reviews.dart';
import 'package:drec/screens/home/consultation/chatDetail.dart';
import 'package:drec/utils/httpException.dart';
import 'package:drec/utils/preference.dart';
import 'package:drec/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/timezone.dart' as tz;

class DoctorSchedule extends StatefulWidget {
  final ListDoctorModel doctor;

  DoctorSchedule(this.doctor);
  static const routeName = '/doctorSchedule';
  @override
  _DoctorScheduleState createState() => _DoctorScheduleState();
}

class _DoctorScheduleState extends State<DoctorSchedule> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String startTime;
  String endTime;
  bool _isLoadingConsultation = false;
  bool _isLoadingSchedule = false;
  bool _isLoadingPage = true;

  @override
  void initState() {
    Provider.of<ScheduleProvider>(context, listen: false)
        .getList(id: widget.doctor.id, date: DateFormat('yyyy-MM-dd').format(_focusedDay))
        .then((_) => setState(() => _isLoadingPage = false));
    super.initState();
  }

  Future<void> scheduleNotification() async {
    final appointmentDate = DateFormat('yyyy-MM-dd').format(_selectedDay) + ' ' + startTime;
    final scheduledTime = DateFormat('yyyy-MM-dd HH:mm').parse(appointmentDate);
    final localTimezoneString = await FlutterNativeTimezone.getLocalTimezone();
    final localTimezone = tz.getLocation(localTimezoneString);
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      'This channel is used for important notifications.',
      icon: '@mipmap/ic_launcher',
      importance: Importance.high,
      styleInformation: BigTextStyleInformation(''),
    );
    final platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Don\'t forget with you\'r appointment',
      'Hi ${UserPreference.name} you have appointment with ${widget.doctor.name} today in $startTime - $endTime',
      tz.TZDateTime.from(scheduledTime.subtract(Duration(minutes: 30)), localTimezone),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Don\'t forget with you\'r appointment',
      'Hi ${UserPreference.name} you have appointment with ${widget.doctor.name} today in $startTime - $endTime',
      tz.TZDateTime.from(scheduledTime.subtract(Duration(minutes: 15)), localTimezone),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    final schedule = Provider.of<ScheduleProvider>(context).list;
    String _docPic = widget.doctor.doctorPicture;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        elevation: 0,
        iconTheme: IconThemeData(color: colorBlack),
        title: Text("Schedule Appointment"),
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      body: _isLoadingPage
          ? Container(
              height: deviceHeight,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 5),
                  Text('Loading...'),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 15),
                      CircleAvatar(
                        radius: 40,
                        child: ClipOval(
                          child: Image.network(
                            _docPic,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.doctor.name}",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                Text('Rp. ${widget.doctor.price}'),
                                SizedBox(width: 4),
                                Text(' ● ', style: TextStyle(color: colorGreyText)),
                                Icon(Icons.star, color: colorPrimary, size: 24),
                                Text('${widget.doctor.rating}'),
                                Text('(${widget.doctor.reviewCount})', style: TextStyle(color: colorGreyText))
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(Duration(days: 30)),
                    focusedDay: _focusedDay,
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: {CalendarFormat.month: 'Month'},
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) async {
                      setState(() => _isLoadingSchedule = true);
                      Provider.of<ScheduleProvider>(context, listen: false)
                          .getList(id: widget.doctor.id, date: DateFormat('yyyy-MM-dd').format(selectedDay))
                          .then((_) => setState(() => _isLoadingSchedule = false));
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay; // update `_focusedDay` here as well
                      });
                    },
                    onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                    calendarStyle: CalendarStyle(canMarkersOverflow: true),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: deviceWidth,
                    height: 40,
                    child: _isLoadingSchedule
                        ? Padding(padding: const EdgeInsets.only(left: 20), child: Text('Please Wait...'))
                        : ListSchedule(
                            schedule,
                            (start, end) {
                              startTime = start;
                              endTime = end;
                            },
                          ),
                  ),
                  SizedBox(height: 20),
                  Button(
                    label: "Review",
                    select: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => Reviews(
                          doctorId: widget.doctor.id,
                          name: widget.doctor.name,
                        ),
                      ),
                    ),
                    gradient: gradientDefault,
                  ),
                  SizedBox(height: 10),
                  Button(
                    label: "Make Appointment",
                    select: () async {
                      if (startTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please choose appointment time'),
                          backgroundColor: Colors.red,
                          elevation: 6,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
                        ));
                      }
                      try {
                        // await Provider.of<ScheduleProvider>(context, listen: false).createAppointment(
                        //   id: widget.doctor.id,
                        //   date: DateFormat('yyyy-MM-dd').format(_selectedDay),
                        //   startTime: startTime,
                        //   endTime: endTime,
                        // );
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Success make a appointment'),
                          backgroundColor: Colors.green,
                          elevation: 6,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
                        ));
                        await scheduleNotification();
                        // Navigator.pop(context);
                      } on HttpException catch (err) {
                        print(err);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(err.message),
                          backgroundColor: Colors.red,
                          elevation: 6,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
                        ));
                      } catch (err) {
                        print(err);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(err.toString()),
                          backgroundColor: Colors.red,
                          elevation: 6,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
                        ));
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  Button(
                    label: _isLoadingConsultation ? "Loading..." : "Live Consultation",
                    gradient: gradientSuccess,
                    select: _isLoadingConsultation
                        ? () {}
                        : () async {
                            setState(() => _isLoadingConsultation = true);
                            try {
                              await firestore.collection('chats').doc('${UserPreference.id}-${widget.doctor.id}').set({
                                'sender_id': UserPreference.id,
                                'sender_name': UserPreference.name,
                                'sender_avatar': UserPreference.avatar,
                                'sender_new_message': false,
                                'receiver_id': widget.doctor.id,
                                'receiver_new_message': false,
                                'receiver_name': widget.doctor.name,
                                'receiver_avatar': widget.doctor.doctorPicture,
                                'last_message': null,
                                'last_message_time': 0,
                              }, SetOptions(merge: true));
                              setState(() => _isLoadingConsultation = false);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatDetail(
                                    id: widget.doctor.id,
                                    name: widget.doctor.name,
                                    imageURL: widget.doctor.doctorPicture,
                                    sender: UserPreference.roleId == 1,
                                  ),
                                ),
                              );
                            } catch (err) {
                              print(err);
                              setState(() => _isLoadingConsultation = false);
                              throw err;
                            }
                          },
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
    );
  }
}
