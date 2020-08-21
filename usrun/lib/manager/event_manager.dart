import 'package:usrun/core/define.dart';
import 'package:usrun/core/net/client.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/model/event_athlete.dart';
import 'package:usrun/model/event_info.dart';
import 'package:usrun/model/event_leaderboard.dart';
import 'package:usrun/model/event_organization.dart';
import 'package:usrun/model/event_team.dart';
import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/team.dart';

class EventManager {
  static List<Event> userEvents = [];

  static Future<Response> getUserEvents() async {
    Map<String, dynamic> params = {};
    Response<dynamic> response =
        await Client.post('/event/getEventOfUser', params);
    List<Event> events = [];
    if (response.object != null)
      events = (response.object as List)
          .map((item) => MapperObject.create<Event>(item))
          .toList();

    userEvents = events;

    Response<List<Event>> result = new Response();

    if (response.success) {
      result.success = true;
      result.object = events;
    } else {
      result.success = false;
      result.errorCode = response.errorCode;
      result.errorMessage = response.errorMessage;
    }
    return result;
  }

  static Future<Response> getNewEventsPaged(int pageNum, int perPage) async {
    Map<String, dynamic> params = {'offset': pageNum, 'limit': perPage};

    Response<dynamic> res = await Client.post('/event/getEventNotJoin', params);

    if (!res.success || (res.object as List).isEmpty) return res;

    List<Event> events = (res.object as List)
        .map((item) => MapperObject.create<Event>(item))
        .toList();

    events.removeWhere((element) => element.status == EventStatus.Ended);

    Response<List<Event>> response = new Response(
      errorCode: res.errorCode,
      success: res.success,
      object: events,
    );

    return response;
  }

  static Future<Response> getUserEventsPaged(
      int userId, int pageNum, int perPage) async {
    Map<String, dynamic> params = {
      'userId': userId,
      'offset': pageNum,
      'limit': perPage
    };

    Response<dynamic> res = await Client.post('/event/getMyEvent', params);

    if (!res.success || (res.object as List).isEmpty) return res;

    List<Event> events = (res.object as List)
        .map((item) => MapperObject.create<Event>(item))
        .toList();

    Response<List<Event>> response = new Response(
      errorCode: res.errorCode,
      success: res.success,
      object: events,
    );

    return response;
  }

  static Future<Response> getEventInfo(int eventId, int userId) async {
    Map<String, dynamic> params = {'eventId': eventId, 'userId': userId};

    Response<dynamic> res = await Client.post('/event/getEventInfo', params);

    if (!res.success) return res;

    EventInfo info = MapperObject.create<EventInfo>(res.object);

    Response<EventInfo> response = new Response(
      errorCode: res.errorCode,
      success: res.success,
      object: info,
    );

    return response;
  }

  static Future<Response> getEventAthlete(
      int eventId, String keyword, int offset, int count) async {
    Map<String, dynamic> params = {
      'eventId': eventId,
      'name': keyword,
      'offset': offset,
      'count': count,
    };

    Response<dynamic> res = await Client.post('/event/getEventAthlete', params);

    if (!res.success) return res;

    EventAthlete athletes = MapperObject.create<EventAthlete>(res.object);

    Response<EventAthlete> response = new Response(
      errorCode: res.errorCode,
      success: res.success,
      object: athletes,
    );

    return response;
  }

  static Future<Response> getEventTeam(
      int eventId, String keyword, int offset, int count) async {
    Map<String, dynamic> params = {
      'eventId': eventId,
      'name': keyword,
      'offset': offset,
      'limit': count,
    };

    Response<dynamic> res = await Client.post('/team/searchTeamByEvent', params);

    if (!res.success) return res;

    List<Team> teams = (res.object as List)
        .map((item) => MapperObject.create<Team>(item))
        .toList();

    Response<List<Team>> response = new Response(
      errorCode: res.errorCode,
      success: res.success,
      object: teams,
    );

    return response;
  }

//  static Future<Response> getEventSponsor(int organizationId) async {
//    Map<String, dynamic> params = {
//      'organizationId': organizationId,
//    };
//
//    Response<dynamic> res = await Client.post('/event/getEventSponsor', params);
//
//    if (!res.success) return res;
//
//    EventOrganization sponsors =
//        MapperObject.create<EventOrganization>(res.object);
//
//    Response<EventOrganization> response = new Response(
//      errorCode: res.errorCode,
//      success: res.success,
//      object: sponsors,
//    );
//
//    return response;
//  }

  static Future<Response> joinEvent(int eventId, int teamId) async {
    Map<String, dynamic> params = {
      'eventId': eventId,
      'teamId': teamId,
    };
    Response<dynamic> res = await Client.post('/event/joinEvent', params);

    return res;
  }

  static Future<Response> leaveEvent(int eventId) async {
    Map<String, dynamic> params = {
      'eventId': eventId,
    };
    Response<dynamic> res = await Client.post('/event/leaveEvent', params);

    return res;
  }

  static Future<Response> getEventLeaderboard(
      int eventId, bool isUserLeaderboard, int top) async {
    Map<String, dynamic> params = {
      'eventId': eventId,
      'top': top,
    };
    Response<dynamic> res;

    if (isUserLeaderboard) {
      res = await Client.post('/event/getUserLeaderBoard', params);
    } else {
      res = await Client.post('/event/getTeamLeaderBoard', params);
    }

    if (!res.success || (res.object as List).length == 0) return res;

    List<EventLeaderboard> leaderboard = (res.object as List)
        .map((item) => MapperObject.create<EventLeaderboard>(item))
        .toList();

    Response<List<EventLeaderboard>> response = new Response(
      errorCode: res.errorCode,
      success: res.success,
      object: leaderboard,
    );

    return response;
  }

  static Future<Response> findEventByName(
      String searchString, int offset, int count) async {
    Map<String, dynamic> params = {
      'name': searchString,
      'offset': offset,
      'limit': count,
    };
    Response<dynamic> res = await Client.post('/event/searchEvent', params);

    if (!res.success || (res.object as List).length == 0) return res;

    List<Event> events = (res.object as List)
        .map((item) => MapperObject.create<Event>(item))
        .toList();

    events.forEach((element) {element.joined = false; element.poweredBy="By Mr.X";});

    Response<List<Event>> response = new Response(
      errorCode: res.errorCode,
      success: res.success,
      object: events,
    );

    return response;
  }
}
