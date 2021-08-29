import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drec/constants.dart' as constant;
import 'package:drec/models/listAppointmentModel.dart';
import 'package:drec/models/reviewsModel.dart';
import 'package:drec/models/userModel.dart';
import 'package:drec/utils/httpException.dart';
import 'package:drec/utils/preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ListAppointmentProvider extends ChangeNotifier {
  List<ListAppointmentModel> appointment = [];
  ListAppointmentModel singleAppointment;

  List<ListAppointmentModel> get list {
    return [...appointment];
  }

  ListAppointmentModel get single {
    return singleAppointment;
  }

  Future<void> getList({
    String doctorName,
    String userName,
    String date,
    int doctorId,
    int userId,
    bool done,
  }) async {
    final dio = Dio();
    final Map<String, dynamic> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${UserPreference.token}"
    };
    dio.options.baseUrl = constant.baseUrl;
    dio.options.headers = headers;

    try {
      final body = {
        "doctor_name": doctorName,
        "user_name": userName,
        "appointment_date": date,
        "user_id": userId,
        "doctor_id": doctorId,
        "done": done,
        "order_column": "id",
        "order_dir": "DESC",
      };
      final res = await dio.get('/appointment', queryParameters: body);

      List<ListAppointmentModel> _appointment = [];
      res.data['data'].asMap().forEach((key, value) => _appointment.add(mapData(value)));

      appointment = _appointment;
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> getSingle(int id) async {
    final dio = Dio();
    final Map<String, dynamic> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${UserPreference.token}"
    };
    dio.options.baseUrl = constant.baseUrl;
    dio.options.headers = headers;

    try {
      final res = await dio.get('/appointment/$id');

      singleAppointment = mapData(res.data['data']);
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> submitResult({int id, String note}) async {
    final dio = Dio();

    try {
      final body = json.encode({"doctor_note": note});
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
      final response = await dio.put('/appointment/submit-result/$id', data: body);

      if (response.statusCode >= 400) {
        throw HttpException(response.data['message']);
      }
    } catch (err) {
      print(err);
      throw err;
    }
  }

  ListAppointmentModel mapData(dynamic value) {
    UserModel doctor;
    UserModel user;
    List<ReviewModel> review = [];

    if (value['doctor'] != null) {
      doctor = UserModel(
        id: value['doctor']['user']['id'],
        specialization: value['doctor']['specialization'],
        name: value['doctor']['user']['name'],
        email: value['doctor']['user']['email'],
        phoneNumber: value['doctor']['user']['no_hp'],
        gender: value['doctor']['user']['jenis_kelamin'],
        dob: value['doctor']['user']['tanggal_lahir'],
        avatar: value['doctor']['user']['avatar'],
        rating: value['doctor']['rating'],
        reviewCount: value['doctor']['reviews_count'],
        price: NumberFormat("#,##0.##").format(value['doctor']['price']),
      );

      if (value['reviews'] != null && value['reviews'].length > 0) {
        value['reviews'].asMap().forEach((k, v) {
          review.add(ReviewModel(
            rating: v['rating'] is int ? v['rating'].toDouble() : v['rating'],
            note: v['note'],
            anonymous: v['anonymous'],
            user: UserModel(id: v['user_id']),
          ));
        });
      }
    }

    if (value['user'] != null) {
      user = UserModel(
        avatar: value['user']['avatar'],
        dob: value['user']['tanggal_lahir'],
        gender: value['user']['jenis_kelamin'],
        phoneNumber: value['user']['no_hp'],
        email: value['user']['email'],
        name: value['user']['name'],
        id: value['user']['id'],
      );
    }

    return ListAppointmentModel(
      id: value['id'],
      appointmentDate: value['appointment_date'],
      appointmentEndTime: value['appointment_time_end'],
      appointmentStartTime: value['appointment_time_start'],
      doctorNote: value['doctor_note'],
      isDone: value['done'],
      doctor: doctor,
      user: user,
      reviews: review,
    );
  }
}
