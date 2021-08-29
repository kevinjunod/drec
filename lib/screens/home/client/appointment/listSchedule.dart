import 'package:drec/constants.dart';
import 'package:drec/models/doctorScheduleModel.dart';
import 'package:flutter/material.dart';

class ListSchedule extends StatefulWidget {
  final List<DoctorScheduleModel> schedule;
  final Function onChanged;
  ListSchedule(this.schedule, this.onChanged);
  static const routeName = '/ListSchedule';
  @override
  _ListScheduleState createState() => _ListScheduleState();
}

class _ListScheduleState extends State<ListSchedule> {
  List<bool> tapped = [];
  @override
  Widget build(BuildContext context) {
    return widget.schedule.length < 1
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('No available time'),
          )
        : ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            itemBuilder: (ctx, idx) {
              tapped.add(false);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    onTap: widget.schedule[idx].available
                        ? () {
                            for (int i = 0; i < widget.schedule.length; i++) {
                              if (i != idx) tapped[i] = false;
                            }
                            setState(() => tapped[idx] = !tapped[idx]);
                            widget.onChanged(widget.schedule[idx].start, widget.schedule[idx].end);
                          }
                        : () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(width: 1.0, color: tapped[idx] ? Colors.white : colorPrimary),
                        color: widget.schedule[idx].available
                            ? tapped[idx]
                                ? colorPrimary
                                : Colors.white
                            : colorGreyText,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "${widget.schedule[idx].start} - ${widget.schedule[idx].end}",
                            style: TextStyle(
                              fontSize: 12,
                              color: tapped[idx] ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: widget.schedule.length,
          );
  }
}
