import 'package:usrun/util/reflector.dart';
import 'package:usrun/model/mapper_object.dart';

@reflector
class Event extends MapperObject {
  int eventId;
  EventStatus status;
  DateTime createTime;
  String eventName;
  String subtitle;
  String thumbnail;
  String poster;
  String banner;
  int totalDistance;
  int totalTeamParticipant;
  int totalParticipant;
  DateTime startTime;
  DateTime endTime;
  String sponsorName;
  bool joined;
}
