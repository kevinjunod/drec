import 'package:drec/models/reviewsModel.dart';
import 'package:drec/models/userModel.dart';

class ListAppointmentModel {
  int id;
  UserModel user;
  UserModel doctor;
  List<ReviewModel> reviews;
  String appointmentDate;
  String appointmentStartTime;
  String appointmentEndTime;
  String doctorNote;
  bool isDone;

  ListAppointmentModel({
    this.id,
    this.user,
    this.doctor,
    this.appointmentDate,
    this.appointmentStartTime,
    this.appointmentEndTime,
    this.doctorNote,
    this.isDone,
    this.reviews,
  });
}
