import 'package:usrun/core/define.dart';
import 'package:usrun/util/reflector.dart';
import 'package:usrun/model/mapper_object.dart';

@reflector
class Event with MapperObject {
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

  Event({
    this.eventId,
    this.status,
    this.createTime,
    this.eventName,
    this.subtitle,
    this.thumbnail,
    this.poster,
    this.banner,
    this.totalDistance,
    this.totalTeamParticipant,
    this.totalParticipant,
    this.startTime,
    this.endTime,
    this.sponsorName,
    this.joined,
  });
}
