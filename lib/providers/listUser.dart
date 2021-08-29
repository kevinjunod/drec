import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drec/constants.dart' as constant;
import 'package:drec/models/userModel.dart';
import 'package:drec/utils/httpException.dart';
import 'package:drec/utils/preference.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListUserProvider with ChangeNotifier {
  List<UserModel> _user = [];

  List<UserModel> get list {
    return [..._user];
  }

  Future<void> getList({@required String token, String name, int roleId}) async {
    final dio = Dio();
    final Map<String, dynamic> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};
    dio.options.baseUrl = constant.baseUrl;
    dio.options.headers = headers;

    try {
      final body = {"name": name, "role_id": roleId != null && roleId > -1 ? roleId : ''};
      final res = await dio.get('/user', queryParameters: body);

      List<UserModel> user = [];
      res.data['data'].asMap().forEach((key, value) {
        user.add(
          UserModel(
            name: value['name'],
            id: value['id'],
            avatar: value['avatar'],
            roleId: value['role_id'],
            phoneNumber: value['no_hp'],
            gender: value['jenis_kelamin'],
            email: value['email'],
            dob: value['tanggal_lahir'],
            address: value['alamat'],
            roleName: value['role']['name'],
            active: value['doctor'] != null ? value['doctor']['active'] : null,
            availableTime: value['doctor'] != null ? value['doctor']['available_time'] : null,
            graduate: value['doctor'] != null ? value['doctor']['graduate'] : null,
            specialization: value['doctor'] != null ? value['doctor']['specialization'] : null,
            price: value['doctor'] != null ? NumberFormat("#,##0.##").format(value['doctor']['price']) : null,
          ),
        );
      });

      _user = user;
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> updateUser({
    @required int id,
    @required int roleId,
    @required String email,
    @required String name,
    @required String address,
    @required String gender,
    @required String dob,
    @required String phoneNumber,
    @required String specialization,
    @required String graduate,
    @required double price,
    @required Map<String, dynamic> availableTime,
    @required bool active,
  }) async {
    final Map<String, dynamic> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${UserPreference.token}"
    };

    final dio = Dio();
    dio.options.baseUrl = constant.baseUrl;
    dio.options.followRedirects = false;
    dio.options.validateStatus = (status) {
      return status < 500;
    };
    dio.options.headers = headers;

    try {
      final body = FormData.fromMap({
        "role_id": roleId,
        "name": name,
        "alamat": address,
        "jenis_kelamin": gender,
        "tanggal_lahir": dob,
        "no_hp": phoneNumber,
        "email": email,
        "specialization": specialization,
        "graduate": graduate,
        "available_time": json.encode(availableTime),
        "price": price,
        "active": active,
      });
      print({
        "role_id": roleId,
        "name": name,
        "alamat": address,
        "jenis_kelamin": gender,
        "tanggal_lahir": dob,
        "no_hp": phoneNumber,
        "email": email,
        "specialization": specialization,
        "graduate": graduate,
        "available_time": json.encode(availableTime),
        "price": price,
        "active": active,
      });

      final url = roleId == 2 ? 'doctor/' + id.toString() : 'user/' + id.toString();
      final response = await dio.put(url, data: body);

      if (response.data['message'] == 'Validation Error') {
        final keys = response.data['error'][0].keys.first;
        throw HttpException(response.data['error'][0][keys]);
      }
      notifyListeners();
      return true;
    } on DioError catch (err) {
      print(err.response.data);
      throw HttpException(err.response.data.toString());
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> addUser({
    @required int roleId,
    @required String email,
    @required String name,
    @required String address,
    @required String gender,
    @required String dob,
    @required String phoneNumber,
    @required String specialization,
    @required String graduate,
    @required double price,
    @required Map<String, dynamic> availableTime,
    @required bool active,
  }) async {
    final Map<String, dynamic> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${UserPreference.token}"
    };

    final dio = Dio();
    dio.options.baseUrl = constant.baseUrl;
    dio.options.followRedirects = false;
    dio.options.validateStatus = (status) {
      return status < 500;
    };
    dio.options.headers = headers;

    try {
      final body = FormData.fromMap({
        "role_id": roleId,
        "name": name,
        "alamat": address,
        "jenis_kelamin": gender,
        "tanggal_lahir": dob,
        "no_hp": phoneNumber,
        "email": email,
        "specialization": specialization,
        "graduate": graduate,
        "available_time": json.encode(availableTime),
        "price": price,
        "active": active,
      });

      final url = roleId == 2 ? 'doctor/by-admin' : 'user/by-admin';
      final response = await dio.post(url, data: body);

      if (response.statusCode == 400) {
        throw HttpException(response.data.toString());
      }

      if (response.statusCode == 409) {
        throw HttpException('Email already used');
      }

      notifyListeners();
      return true;
    } on DioError catch (err) {
      print(err.response.data);
      throw HttpException(err.response.data.toString());
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> deleteUser(int id) async {
    final Map<String, dynamic> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${UserPreference.token}"
    };

    final dio = Dio();
    dio.options.baseUrl = constant.baseUrl;
    dio.options.followRedirects = false;
    dio.options.validateStatus = (status) {
      return status < 500;
    };
    dio.options.headers = headers;

    try {
      await dio.delete('user/' + id.toString());
    } on DioError catch (err) {
      print(err.response.data);
      throw HttpException(err.response.data.toString());
    } catch (err) {
      print(err);
      throw err;
    }
  }
}
