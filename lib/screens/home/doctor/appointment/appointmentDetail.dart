import 'package:drec/constants.dart';
import 'package:drec/models/listAppointmentModel.dart';
import 'package:drec/providers/listAppointment.dart';
import 'package:drec/utils/httpException.dart';
import 'package:drec/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppointmentDetail extends StatefulWidget {
  final ListAppointmentModel appointment;
  final String name;
  final String date;
  const AppointmentDetail({@required this.appointment, @required this.name, @required this.date, Key key})
      : super(key: key);

  @override
  _AppointmentDetailState createState() => _AppointmentDetailState();
}

class _AppointmentDetailState extends State<AppointmentDetail> {
  final unescape = HtmlUnescape();
  TextEditingController result = new TextEditingController();
  bool _isLoading = false;
  bool _hasNote = false;

  @override
  void initState() {
    setState(() {
      result.text = widget.appointment.doctorNote != null ? unescape.convert(widget.appointment.doctorNote) : '';
      if (widget.appointment.doctorNote != null) {
        _hasNote = true;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('yyyy-MM-dd').parse(widget.appointment.appointmentDate);
    final startTime = DateFormat('HH:mm:ss').parse(widget.appointment.appointmentStartTime);
    final endTime = DateFormat('HH:mm:ss').parse(widget.appointment.appointmentEndTime);
    final dob = widget.appointment.user.dob;
    final dur = DateTime.now().difference(DateFormat('yyyy-MM-dd').parse(dob));
    final diff = (dur.inDays / 365).floor().toString();

    Widget alert = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Ok'),
          onPressed: () async {
            setState(() => _isLoading = true);
            try {
              await Provider.of<ListAppointmentProvider>(context, listen: false).submitResult(
                id: widget.appointment.id,
                note: result.text,
              );
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Success submit result'),
                backgroundColor: Colors.green,
                elevation: 6,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
              ));
              setState(() {
                _isLoading = false;
                _hasNote = true;
              });
              Provider.of<ListAppointmentProvider>(context, listen: false)
                  .getList(userName: widget.name, date: widget.date)
                  .then((_) => setState(() => _isLoading = false));
            } on HttpException catch (err) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(err.message),
                backgroundColor: colorPrimary,
                elevation: 6,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
              ));
              setState(() => _isLoading = false);
            } catch (err) {
              print(err);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Internal Server Error. Please try again."),
                backgroundColor: Colors.red,
                elevation: 6,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
              ));
              setState(() => _isLoading = false);
            }
            Navigator.of(context).pop();
          },
        )
      ],
    );

    AlertDialog _alertLogout = AlertDialog(
      content: Text("Are you sure with this note ? \nNote can only be submitted once"),
      actions: [alert],
    );

    return Scaffold(
      appBar: AppBar(title: Text('Appointment Detail')),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: ClipOval(
                        child: Image.network(
                          widget.appointment.user.avatar,
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
                            "${widget.appointment.user.name}",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 5),
                          Text('$diff years')
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Table(
                  columnWidths: {
                    0: FlexColumnWidth(1.5),
                    1: FlexColumnWidth(3),
                  },
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Gender',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(widget.appointment.user.gender == 'L' ? 'Male' : 'Female'),
                          ),
                        )
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(DateFormat('dd MMMM yyyy').format(date)),
                          ),
                        )
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Time',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)} WIB',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                TextField(
                  maxLength: 1000,
                  minLines: 5,
                  maxLines: null,
                  controller: result,
                  readOnly: _hasNote,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Result',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Button(
                  label: _isLoading ? 'Please Wait' : 'Submit',
                  gradient: gradientPrimary,
                  select: _isLoading || _hasNote
                      ? () {}
                      : () => showDialog(context: context, builder: (BuildContext context) => _alertLogout),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
