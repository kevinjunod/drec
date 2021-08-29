import 'package:drec/constants.dart';
import 'package:drec/providers/listAppointment.dart';
import 'package:drec/screens/home/client/history/listHistory.dart';
import 'package:drec/utils/preference.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryAppointmentClient extends StatefulWidget {
  HistoryAppointmentClient();
  static const routeName = '/historyAppointmentClient';
  @override
  _HistoryAppointmentClientState createState() => _HistoryAppointmentClientState();
}

class _HistoryAppointmentClientState extends State<HistoryAppointmentClient> {
  bool _isLoading = true;
  TextEditingController date = new TextEditingController();
  TextEditingController doctor = new TextEditingController();

  @override
  void initState() {
    Provider.of<ListAppointmentProvider>(context, listen: false)
        .getList(userId: UserPreference.id)
        .then((_) => setState(() => _isLoading = false));
    super.initState();
  }

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
            .getList(date: date.text, doctorName: doctor.text, userId: UserPreference.id)
            .then((_) => setState(() => _isLoading = false));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<ListAppointmentProvider>(context).list;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        color: colorPrimary,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: devicePaddingTop + 15, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Doctor Name...",
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
                ),
                controller: doctor,
                onChanged: (val) {
                  setState(() => _isLoading = true);
                  Provider.of<ListAppointmentProvider>(context, listen: false)
                      .getList(doctorName: val, date: date.text)
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
                                .getList(date: date.text, doctorName: doctor.text, userId: UserPreference.id)
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
                : list.length > 0
                    ? Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: ListView.builder(
                            padding: EdgeInsets.only(top: 8),
                            itemBuilder: (_, index) => ListHistory(list[index]),
                            itemCount: list.length,
                            shrinkWrap: true,
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(15),
                        child: Text('Belum ada history...', style: TextStyle(fontStyle: FontStyle.italic)),
                      ),
          ],
        ),
      ),
    );
  }
}
