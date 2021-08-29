import 'package:drec/constants.dart';
import 'package:drec/providers/listAppointment.dart';
import 'package:drec/screens/home/doctor/appointment/appointmentDetail.dart';
import 'package:drec/utils/preference.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListAppointment extends StatefulWidget {
  ListAppointment();
  static const routeName = '/listAppointment';
  @override
  _ListAppointmentState createState() => _ListAppointmentState();
}

class _ListAppointmentState extends State<ListAppointment> {
  TextEditingController date = new TextEditingController();
  TextEditingController user = new TextEditingController();
  bool _isLoading = true;

  Future<Null> _selectDate() async {
    if (!_isLoading) {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        setState(() {
          date.text = DateFormat("yyyy-MM-dd").format(picked);
          _isLoading = true;
        });
        Provider.of<ListAppointmentProvider>(context, listen: false)
            .getList(date: date.text)
            .then((_) => setState(() => _isLoading = false));
      }
    }
  }

  @override
  void initState() {
    Provider.of<ListAppointmentProvider>(context, listen: false)
        .getList(doctorId: UserPreference.id, done: false)
        .then((_) => setState(() => _isLoading = false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<ListAppointmentProvider>(context).list;

    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Patient Name...",
                hintStyle: TextStyle(color: colorGreyText),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade600, size: 20),
                filled: true,
                fillColor: colorLightPrimary,
                contentPadding: EdgeInsets.all(8),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: colorLightGrey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: colorLightGrey),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      user.text = '';
                      _isLoading = true;
                    });
                    Provider.of<ListAppointmentProvider>(context, listen: false)
                        .getList(date: user.text, userName: user.text)
                        .then((_) => setState(() => _isLoading = false));
                  },
                  child: Icon(Icons.clear, color: colorGreyText),
                ),
              ),
              controller: user,
              onChanged: (val) {
                setState(() => _isLoading = true);
                Provider.of<ListAppointmentProvider>(context, listen: false)
                    .getList(userName: val, date: date.text)
                    .then((_) => setState(() => _isLoading = false));
              },
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 60,
            width: deviceWidth,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Date :',
                    softWrap: true,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Container(
                  height: 60,
                  width: (deviceWidth - 32) * 0.8,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Date here...",
                      hintStyle: TextStyle(color: colorGreyText),
                      filled: true,
                      fillColor: colorLightPrimary,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: colorLightGrey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: colorLightGrey),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            date.text = '';
                            _isLoading = true;
                          });
                          Provider.of<ListAppointmentProvider>(context, listen: false)
                              .getList(date: date.text, userName: user.text)
                              .then((_) => setState(() => _isLoading = false));
                        },
                        child: Icon(Icons.clear, color: colorGreyText),
                      ),
                    ),
                    controller: date,
                    onTap: _selectDate,
                    showCursor: false,
                    readOnly: true,
                  ),
                ),
              ],
            ),
          ),
          _isLoading
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 5),
                      Text('Loading...'),
                    ],
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, idx) {
                      final appointDate = DateFormat('yyyy-MM-dd').parse(list[idx].appointmentDate);
                      final startTime = DateFormat('HH:mm:ss').parse(list[idx].appointmentStartTime);
                      final endTime = DateFormat('HH:mm:ss').parse(list[idx].appointmentEndTime);
                      final timeFormat = DateFormat('HH:mm');

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadiusDirectional.circular(7),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: .5,
                              blurRadius: 3,
                              offset: Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(right: 15, left: 15, bottom: 10),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => AppointmentDetail(
                                  appointment: list[idx],
                                  name: user.text,
                                  date: date.text,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    child: ClipOval(
                                      child: Image.network(
                                        list[idx].user.avatar,
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          list[idx].user.name,
                                          style: TextStyle(fontSize: 18, letterSpacing: .5),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          DateFormat('dd MMMM yyyy').format(appointDate),
                                          style: TextStyle(color: colorGreyText, fontSize: 13),
                                        ),
                                        Text(
                                          timeFormat.format(startTime) + ' - ' + timeFormat.format(endTime) + ' WIB',
                                          style: TextStyle(color: colorGreyText, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: list.length,
                  ),
                ),
        ],
      ),
    );
  }
}
