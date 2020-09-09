import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/util/reflector.dart';

@reflector
class TeamStatItem extends MapperObject {
  int rank;
  int totalDistance;
  DateTime maxTime;
  int maxDistance;
  int memInWeek;
  int totalActivity;

  TeamStatItem({
    rank = -1,
    totalDistance = 0,
    maxTime = 0,
    maxDistance = 0,
    memInWeek = 0,
    totalMember = 0,
    totalActivity = 0,
  });
}
