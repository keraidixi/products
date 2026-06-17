import 'package:hive/hive.dart';

part 'auth_model.g.dart';

@HiveType(typeId: 0)
class UserModel {

  @HiveField(0)
  final String email;

  @HiveField(1)
  final String password;

  @HiveField(2)
  final String address;

  @HiveField(3)
  final String phone;

  UserModel({
    required this.email,
    required this.password,
    required this.address,
    required this.phone,
  });
}