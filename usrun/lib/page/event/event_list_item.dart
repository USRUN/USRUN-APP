
import 'package:intl/intl.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/model/event.dart';

class EventListItem{
  int id;
  String avatar;
  String title;
  String subtitle;
  String sponsorName;
  int totalParticipant;
  int totalTeamParticipant;
  bool joined;
  String startDate;
  String endDate;
  String status;

  EventListItem.fromEvent(Event event){
    this.id = event.eventId;
    this.avatar = event.thumbnail;
    this.title = event.eventName;
    this.subtitle = event.subtitle;
    this.sponsorName = event.sponsorName;
    this.totalParticipant = event.totalParticipant;
    this.totalTeamParticipant = event.totalTeamParticipant;
    this.startDate = DateFormat().format(event.startTime);
    this.endDate = DateFormat().format(event.endTime);
    this.status = R.strings.eventStatus[event.status.index];
    this.joined = event.joined;
  }
}