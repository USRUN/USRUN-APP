import 'package:usrun/core/define.dart';

import 'package:usrun/util/reflector.dart';

import 'package:usrun/model/mapper_object.dart';

@reflector
class TeamLeaderboard extends MapperObject {
  int userId;
  String displayName;
  String avatar;
  int totalDistance;
}