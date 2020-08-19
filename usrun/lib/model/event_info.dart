import 'package:usrun/core/define.dart';
import 'package:usrun/model/event_organization.dart';
import 'package:usrun/util/reflector.dart';
import 'package:usrun/model/mapper_object.dart';

@reflector
class EventInfo with MapperObject {
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
  int totalActivities;
  int leadingDistance;
  DateTime leadingTime;
  DateTime startTime;
  DateTime endTime;
  String description;
  List<EventOrganization> organization;

  bool joined;
  bool finished;
  int userRank;
  int userDistance;
  int userTime;

  EventInfo({
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
    this.totalActivities,
    this.leadingDistance,
    this.leadingTime,
    this.startTime,
    this.endTime,
    this.joined,
    this.finished,
    this.description,
    this.organization,
    this.userRank,
    this.userDistance,
    this.userTime,
  });
}
