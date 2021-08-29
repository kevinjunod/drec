class UserModel {
  int id;
  int roleId;
  String roleName;
  String email;
  String name;
  String address;
  String gender;
  String dob;
  String phoneNumber;
  String token;
  String avatar;
  String specialization;
  String graduate;
  String price;
  Map<String, dynamic> availableTime;
  bool active;
  final String rating;
  final int reviewCount;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.address,
    this.gender,
    this.dob,
    this.phoneNumber,
    this.token,
    this.roleId,
    this.roleName,
    this.avatar,
    this.specialization,
    this.graduate,
    this.availableTime,
    this.price,
    this.active,
    this.reviewCount,
    this.rating,
  });
}
