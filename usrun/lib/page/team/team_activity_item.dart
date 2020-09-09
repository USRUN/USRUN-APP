import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/util/reflector.dart';

@reflector
class TeamActivityItem extends MapperObject {
  int userActivityId;
  int userId;
  DateTime createTime;
  int totalDistance;
  int totalTime;
  int totalStep;
  double avgPace;
  double avgHeart;
  double maxHeart;
  int calories;
  double elevGain;
  double elevMax;
  List<String> photos;
  String title;
  String description;
  int totalLove;
  int totalComment;
  int totalShare;
  bool processed;

  TeamActivityItem({
    this.userId = -1,
    this.userActivityId = -1,
    this.title = "No title",
    this.description = "No description",
    this.processed = false,
    this.totalDistance = 0,
    this.totalTime = 0,
    this.totalStep = 0,
    this.avgPace = 0.0,
    this.avgHeart = 0.0,
    this.maxHeart = 0.0,
    this.calories = 0,
  }) : assert(userId != null && userActivityId != null && title != null);
}
