import 'package:usrun/model/mapper_object.dart';

class UserActivity extends MapperObject{
  int userActivityId;
  int userId;
  String userDisplayName;
  int eventId;
  String eventName;
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
}