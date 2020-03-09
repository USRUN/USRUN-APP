import 'package:usrun/core/define.dart';

import 'package:usrun/util/reflector.dart';

import 'package:usrun/model/mapper_object.dart';


@reflector
class Event extends MapperObject {
  int eventId;
  String name;
  SportType sportType;
  String description;
  DateTime startDate;
  DateTime endDate;
  DateTime updateDate;
  EventType type;
  String img;
  String logo;
  bool isActive;
  int memberCount;
  int teamCount;
  num distance;
  UserRole userType;
}