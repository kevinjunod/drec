import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drec/constants.dart' as constant;
import 'package:drec/models/doctorScheduleModel.dart';
import 'package:drec/utils/httpException.dart';
import 'package:drec/utils/preference.dart';
import 'package:flutter/material.dart';

class ScheduleProvider extends ChangeNotifier {
  List<DoctorScheduleModel> _schedule = [];

  List<DoctorScheduleModel> get list {
    return [..._schedule];
  }

  Future<void> getList({@required int id, @required String date}) async {
    final dio = Dio();
    final Map<String, dynamic> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${UserPreference.token}",
    };
    dio.options.baseUrl = constant.baseUrl;
    dio.options.headers = headers;

    try {
      final body = {"date": date};

      final res = await dio.get('/doctor/schedule/$id', queryParameters: body);

      List<DoctorScheduleModel> schedule = [];
      res.data['data'].asMap().forEach((key, value) {
        schedule.add(
          DoctorScheduleModel(start: value['start'], end: value['end'], available: value['available']),
        );
      });

      _schedule = schedule;
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> createAppointment({
    @required int id,
    @required String date,
    @required String startTime,
    @required String endTime,
  }) async {
    final dio = Dio();

    try {
      final body = json.encode({
        "user_id": UserPreference.id,
        "doctor_id": id,
        "appointment_date": date,
        "appointment_time_start": startTime,
        "appointment_time_end": endTime,
      });
      print(body);
      final Map<String, dynamic> headers = {
        "Content-type": "application/json",
        "Authorization": "Bearer ${UserPreference.token}",
      };

      dio.options.baseUrl = constant.baseUrl;
      dio.options.headers = headers;
      dio.options.followRedirects = false;
      dio.options.validateStatus = (status) {
        return status < 500;
      };
      final response = await dio.post('/appointment', data: body);
      print(response.data);
      if (response.statusCode >= 400) {
        throw HttpException(response.data['message']);
      }
    } catch (err) {
      print(err);
      throw err;
    }
  }
}
