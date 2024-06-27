
import 'package:hive/hive.dart';
@HiveType(typeId: 1)
class User {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int age;

  @HiveField(2)
  final DateTime createdAt;

  User({required this.name, required this.age, required this.createdAt});
}