import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drec/constants.dart' as constant;
import 'package:drec/models/reviewsModel.dart';
import 'package:drec/models/userModel.dart';
import 'package:drec/utils/httpException.dart';
import 'package:drec/utils/preference.dart';
import 'package:flutter/cupertino.dart';

class ReviewsProvider extends ChangeNotifier {
  List<ReviewModel> reviews = [];

  List<ReviewModel> get list {
    return [...reviews];
  }

  Future<void> getList({int doctorId}) async {
    final dio = Dio();
    final Map<String, dynamic> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${UserPreference.token}"
    };
    dio.options.baseUrl = constant.baseUrl;
    dio.options.headers = headers;

    try {
      final body = {"doctor_id": doctorId};
      final res = await dio.get('/review', queryParameters: body);

      List<ReviewModel> _review = [];
      res.data['data'].asMap().forEach((key, value) {
        final user =
            value['user'] != null ? UserModel(name: value['user']['name'], avatar: value['user']['avatar']) : null;
        _review.add(
          ReviewModel(
            user: UserModel(
              name: value['user'] != null ? value['user']['name'] : 'anonymous',
              avatar: value['user'] != null
                  ? value['user']['avatar']
                  : 'http://178.128.63.183:3802/assets/avatar/default.png',
            ),
            anonymous: user == null ? true : value['anonymous'],
            note: value['note'],
            rating: value['rating'] is int ? value['rating'].toDouble() : value['rating'],
            createdDate: DateTime.parse(value['createdAt']),
          ),
        );
      });

      reviews = _review;
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> createReview({
    @required double rating,
    @required bool anonymous,
    @required String note,
    @required int doctorId,
    @required int appointmentId,
  }) async {
    final dio = Dio();

    try {
      final body = json.encode({
        "appointment_id": appointmentId,
        "user_id": UserPreference.id,
        "doctor_id": doctorId,
        "rating": rating,
        "anonymous": anonymous,
        "note": note,
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
      final response = await dio.post('/review', data: body);
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
