import 'package:drec/constants.dart';
import 'package:drec/models/listAppointmentModel.dart';
import 'package:drec/screens/home/client/history/historyDetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListHistory extends StatelessWidget {
  final ListAppointmentModel appointment;
  ListHistory(this.appointment, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appointmentDate = DateFormat('yyyy-MM-dd').parse(appointment.appointmentDate);
    final appointmentStartTime = DateFormat('HH:mm:ss').parse(appointment.appointmentStartTime);
    final appointmentEndTime = DateFormat('HH:mm:ss').parse(appointment.appointmentEndTime);
    final textColor = appointment.isDone ? Colors.green : colorPrimary;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 1.5,
            blurRadius: 5,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      margin: EdgeInsets.only(right: 15, left: 15, bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => HistoryDetail(appointment))),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: Image.network(
                      appointment.doctor.avatar,
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
                        appointment.doctor.name,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18,
                          letterSpacing: .5,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Date: ${DateFormat('dd MMMM yyyy').format(appointmentDate)}',
                        style: TextStyle(color: colorGreyText, fontSize: 13),
                      ),
                      Text(
                        'Time: ${DateFormat('HH:mm').format(appointmentStartTime)} - ${DateFormat('HH:mm').format(appointmentEndTime)}',
                        style: TextStyle(color: colorGreyText, fontSize: 13),
                      ),
                      appointment.isDone
                          ? Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                'Let\'s see doctor notes',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 13,
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                'Scheduled soon',
                                style: TextStyle(
                                  color: colorPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                appointment.isDone
                    ? Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 35,
                      )
                    : Icon(
                        Icons.history_outlined,
                        color: colorPrimary,
                        size: 35,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
