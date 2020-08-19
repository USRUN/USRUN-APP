import 'package:usrun/core/define.dart';
import 'package:usrun/util/reflector.dart';
import 'package:usrun/model/mapper_object.dart';

@reflector
class Event with MapperObject {
  int eventId;
  EventStatus status;
  String eventName;
  String subtitle;
  String thumbnail;
  String banner;
  int totalTeamParticipant;
  int totalParticipant;
  DateTime startTime;
  DateTime endTime;
  String poweredBy;
  bool joined;

  Event({
    this.eventId,
    this.status,
    this.eventName,
    this.subtitle,
    this.thumbnail,
    this.totalTeamParticipant,
    this.totalParticipant,
    this.startTime,
    this.endTime,
    this.poweredBy,
    this.joined,
  });
}
