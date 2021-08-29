import 'package:drec/constants.dart';
import 'package:drec/models/listDoctorModel.dart';
import 'package:drec/screens/home/client/appointment/doctorSchedule.dart';
import 'package:flutter/material.dart';

class ListDoctor extends StatefulWidget {
  final List<ListDoctorModel> doctor;
  ListDoctor(this.doctor);
  static const routeName = '/listDoctor';
  @override
  _ListDoctorState createState() => _ListDoctorState();
}

class _ListDoctorState extends State<ListDoctor> {
  @override
  Widget build(BuildContext context) {
    return widget.doctor.length < 1
        ? Container(
            padding: EdgeInsets.all(10),
            child: Text('Sorry, there\'s no available doctor yet', style: TextStyle(fontStyle: FontStyle.italic)),
          )
        : ListView.builder(
            itemBuilder: (ctx, idx) {
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
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorSchedule(widget.doctor[idx]),
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
                                widget.doctor[idx].doctorPicture,
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
                                  widget.doctor[idx].name,
                                  style: TextStyle(fontSize: 18, letterSpacing: .5),
                                ),
                                Text(widget.doctor[idx].specialization, style: TextStyle(color: colorGreyText)),
                                Text('Since ${widget.doctor[idx].experience}', style: TextStyle(color: colorGreyText)),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text('Rp. ${widget.doctor[idx].price}', style: TextStyle(color: colorGreyText)),
                                    SizedBox(width: 6),
                                    Text('●', style: TextStyle(color: colorGreyText)),
                                    SizedBox(width: 6),
                                    Icon(Icons.star, color: colorPrimary, size: 18),
                                    Text(
                                      '${widget.doctor[idx].rating}',
                                      style: TextStyle(
                                        color: colorGreyText,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      ' (${widget.doctor[idx].reviewCount})',
                                      style: TextStyle(
                                        color: colorGreyText,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
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
            itemCount: widget.doctor.length,
          );
  }
}
