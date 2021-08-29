import 'package:dio/dio.dart';
import 'package:drec/constants.dart' as constant;
import 'package:drec/models/listDoctorModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListDoctorProvider with ChangeNotifier {
  List<ListDoctorModel> doctor = [];

  List<ListDoctorModel> get list {
    return [...doctor];
  }

  Future<void> getList(String token, {String name}) async {
    final dio = Dio();
    final Map<String, dynamic> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};
    dio.options.baseUrl = constant.baseUrl;
    dio.options.headers = headers;

    try {
      final body = {"active": true, "name": name};
      final res = await dio.get('/doctor', queryParameters: body);

      List<ListDoctorModel> _doctors = [];
      res.data['data'].asMap().forEach((key, value) {
        final graduate = DateFormat('yyyy-MM-dd').parse(value['graduate']);
        final now = DateTime.now();

        int years = now.year - graduate.year;
        int months = now.month - graduate.month;
        int days = now.day - graduate.day;

        if (months < 0 || (months == 0 && days < 0)) {
          years--;
          months += (days < 0 ? 11 : 12);
        }

        _doctors.add(ListDoctorModel(
          name: value['user']['name'],
          id: value['user']['id'],
          doctorPicture: value['user']['avatar'],
          specialization: value['specialization'],
          experience: '$years years $months month',
          rating: value['rating'] is int ? value['rating'].toDouble() : double.parse(value['rating']),
          reviewCount: value['reviews_count'],
          price: NumberFormat("#,##0.##").format(value['price']),
        ));
      });

      doctor = _doctors;
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }
}
