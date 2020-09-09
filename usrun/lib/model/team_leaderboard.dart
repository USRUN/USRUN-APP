import 'package:usrun/util/reflector.dart';
import 'package:usrun/model/mapper_object.dart';

@reflector
class TeamLeaderboard with MapperObject {
  int userId;
  String displayName;
  String avatar;
  int totalDistance;
}