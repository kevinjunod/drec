import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  static SharedPreferences _instance;
  static SharedPreferences get instance => _instance;

  static init() async {
    _instance = await SharedPreferences.getInstance();
  }

  static set id(int id) {
    _instance.setInt('id', id);
  }

  static int get id {
    return _instance.getInt('id') ?? 0;
  }

  static set roleId(int roleId) {
    _instance.setInt('roleId', roleId);
  }

  static int get roleId {
    return _instance.getInt('roleId') ?? 0;
  }

  static set isLogin(bool isLogin) {
    _instance.setBool('isLogin', isLogin);
  }

  static bool get isLogin {
    return _instance.getBool('isLogin') ?? false;
  }

  static set address(String address) {
    _instance.setString('address', address);
  }

  static String get address {
    return _instance.getString('address');
  }

  static set dob(String dob) {
    _instance.setString('dob', dob);
  }

  static String get dob {
    return _instance.getString('dob');
  }

  static set email(String email) {
    _instance.setString('email', email);
  }

  static String get email {
    return _instance.getString('email');
  }

  static set name(String name) {
    _instance.setString('name', name);
  }

  static String get name {
    return _instance.getString('name');
  }

  static set gender(String gender) {
    _instance.setString('gender', gender);
  }

  static String get gender {
    return _instance.getString('gender');
  }

  static set phoneNumber(String phoneNumber) {
    _instance.setString('phoneNumber', phoneNumber);
  }

  static String get phoneNumber {
    return _instance.getString('phoneNumber');
  }

  static set token(String token) {
    _instance.setString('token', token);
  }

  static String get token {
    return _instance.getString('token');
  }

  static set avatar(String avatar) {
    _instance.setString('avatar', avatar);
  }

  static String get avatar {
    return _instance.getString('avatar');
  }

  static set specialization(String specialization) {
    _instance.setString('specialization', specialization);
  }

  static String get specialization {
    return _instance.getString('specialization');
  }

  static set graduate(String graduate) {
    _instance.setString('graduate', graduate);
  }

  static String get graduate {
    return _instance.getString('graduate');
  }

  static set availableTime(String availableTime) {
    _instance.setString('availableTime', availableTime);
  }

  static String get availableTime {
    return _instance.getString('availableTime');
  }

  static set price(String price) {
    _instance.setString('price', price);
  }

  static String get price {
    return _instance.getString('price');
  }

  static set active(bool active) {
    _instance.setBool('active', active);
  }

  static bool get active {
    return _instance.getBool('active') ?? false;
  }

  static void reset() {
    isLogin = false;
    id = 0;
    roleId = 0;
    address = '';
    dob = '';
    email = '';
    name = '';
    gender = '';
    phoneNumber = '';
    token = '';
    avatar = '';
    specialization = '';
    graduate = '';
    availableTime = '';
    price = '';
    active = false;
  }
}
