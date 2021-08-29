import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drec/constants.dart' as constant;
import 'package:drec/utils/httpException.dart';
import 'package:drec/utils/preference.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier {
  Future<int> login({
    @required String email,
    @required String password,
  }) async {
    final dio = Dio();

    try {
      final body = json.encode({
        "email": email,
        "password": password,
      });

      dio.options.baseUrl = constant.baseUrl;
      dio.options.followRedirects = false;
      dio.options.validateStatus = (status) {
        return status < 500;
      };
      final response = await dio.post('/auth/login', data: body);

      if (response.statusCode == 400) {
        throw HttpException(response.data['message']);
      }
      if (response.statusCode == 401) {
        throw HttpException('Credential Not Valid');
      }
      UserPreference.id = response.data['data']['id'];
      UserPreference.address = response.data['data']['alamat'];
      UserPreference.avatar = response.data['data']['avatar'];
      UserPreference.dob = response.data['data']['tanggal_lahir'];
      UserPreference.email = response.data['data']['email'];
      UserPreference.gender = response.data['data']['jenis_kelamin'];
      UserPreference.isLogin = true;
      UserPreference.name = response.data['data']['name'];
      UserPreference.phoneNumber = response.data['data']['no_hp'];
      UserPreference.roleId = response.data['data']['role_id'];
      UserPreference.token = response.data['data']['token'];

      if (response.data['data']['role_id'] == 2) {
        UserPreference.active = response.data['data']['doctor.active'];
        UserPreference.availableTime = json.encode(response.data['data']['doctor.available_time']);
        UserPreference.graduate = response.data['data']['doctor.graduate'];
        UserPreference.specialization = response.data['data']['doctor.specialization'];
        UserPreference.price = response.data['data']['doctor.price'].toString();
      }

      return UserPreference.roleId;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<bool> logout() async {
    try {
      UserPreference.reset();

      return true;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<bool> register({
    @required int roleId,
    @required String email,
    @required String password,
    @required String confirmationPassword,
    @required String name,
    @required String address,
    @required String gender,
    @required String dob,
    @required String phoneNumber,
    @required String avatar,
  }) async {
    final dio = Dio();
    dio.options.baseUrl = constant.baseUrl;
    dio.options.followRedirects = false;
    dio.options.validateStatus = (status) {
      return status < 500;
    };

    try {
      final body = FormData.fromMap({
        "name": name,
        "alamat": address,
        "jenis_kelamin": gender,
        "tanggal_lahir": dob,
        "no_hp": phoneNumber,
        "role_id": roleId,
        "email": email,
        "password": password,
        "confirmation_password": confirmationPassword,
        "avatar": avatar != '' ? await MultipartFile.fromFile(avatar, filename: "avatar_$name.png") : ''
      });

      await dio.post('auth/register', data: body);

      return true;
    } on DioError catch (err) {
      print(err.response.data);
      throw HttpException(err.response.data.toString());
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<bool> update({
    @required String email,
    @required String password,
    @required String confirmationPassword,
    @required String name,
    @required String address,
    @required String gender,
    @required String dob,
    @required String phoneNumber,
    @required String avatar,
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
      final pattern = new RegExp(r'^http:');
      final body = FormData.fromMap({
        "role_id": UserPreference.roleId,
        "name": name,
        "alamat": address,
        "jenis_kelamin": gender,
        "tanggal_lahir": dob,
        "no_hp": phoneNumber,
        "email": email,
        "password": password,
        "confirmation_password": confirmationPassword,
        "specialization": specialization,
        "graduate": graduate,
        "available_time": json.encode(availableTime),
        "price": price,
        "active": active,
        "avatar": pattern.hasMatch(avatar) ? null : await MultipartFile.fromFile(avatar, filename: "avatar_$name.png"),
      });

      final url = UserPreference.roleId == 2
          ? 'doctor/' + UserPreference.id.toString()
          : 'user/' + UserPreference.id.toString();

      final response = await dio.put(url, data: body);

      UserPreference.address = response.data['data']['alamat'];
      UserPreference.avatar = response.data['data']['avatar'];
      UserPreference.dob = response.data['data']['tanggal_lahir'];
      UserPreference.email = response.data['data']['email'];
      UserPreference.gender = response.data['data']['jenis_kelamin'];
      UserPreference.name = response.data['data']['name'];
      UserPreference.phoneNumber = response.data['data']['no_hp'];

      return true;
    } on DioError catch (err) {
      print(err.response.data);
      throw HttpException(err.response.data.toString());
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> resetPassword(String email) async {
    final dio = Dio();
    dio.options.baseUrl = constant.baseUrl;
    dio.options.followRedirects = false;
    dio.options.validateStatus = (status) {
      return status < 500;
    };

    try {
      final response = await dio.post('/auth/forgot-password', data: {"email": email});

      if (response.statusCode == 401) {
        throw HttpException('Credential Not Valid');
      }
    } catch (err) {
      print(err);
      throw err;
    }
  }
}
