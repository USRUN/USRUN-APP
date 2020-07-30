import 'package:usrun/core/net/client.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/model/response.dart';

class EventManager {
  static List<Event> userEvents = [];

  static Future<Response> getUserEvents() async {

    Map<String,dynamic> params = {};
    Response<dynamic> response = await Client.post('/event/getEventOfUser',params);
    List<Event> events = [];
    if (response.object != null)
      events = (response.object as List)
          .map((item)=> MapperObject.create<Event>(item)).toList();

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

  static Future<Response> getAllEventsPaged(int pageNum, int perPage) async {
    Map<String,dynamic> params = {
      'offset': pageNum,
      'count': perPage
    };

    Response<dynamic> res = await Client.post('/event/getAllEvent',params);

    if(!res.success || (res.object as List).isEmpty) return res;

    List<Event> events = (res.object as List)
        .map((item)=> MapperObject.create<Event>(item)).toList();

    Response<List<Event>> response = new Response(
        errorCode: res.errorCode,
        success: res.success,
        object: events
    );

    return response;
  }

  static Future<Response> getEventDetails(int eventId) async {

  }

  static Future<Response> getEventInfo(int eventId) async {

  }

  static Future<Response> getEventAthlete(int eventId) async {

  }

  static Future<Response> getEventTeam(int eventId) async {

  }

  static Future<Response> getEventSponsor(int eventId) async {

  }

  static Future<Response> joinEvent(int eventId, int teamId, int userId) async {
    Map<String, dynamic> params = {
      'eventId': eventId,
      'teamId': teamId,
      'userId': userId,
    };
    Response<dynamic> res = await Client.post('/event/joinEvent', params);

    return res;
  }

  static Future<Response> leaveEvent(int eventId, int teamId, int userId) async {
    Map<String, dynamic> params = {
      'eventId': eventId,
      'teamId': teamId,
      'userId': userId,
    };
    Response<dynamic> res = await Client.post('/event/leaveEvent', params);

    return res;
  }

  static Future<Response> getEventLeaderboardByUser(int eventId) async {
    Map<String, dynamic> params = {
      'eventId': eventId,
    };
    Response<dynamic> res = await Client.post('/event/getLeaderboardByUser', params);

    return res;
  }

  static Future<Response> getEventLeaderboardByTeam(int eventId) async {
    Map<String, dynamic> params = {
      'eventId': eventId,
    };
    Response<dynamic> res = await Client.post('/event/getLeaderboardByTeam', params);

    return res;
  }

  static Future<Response> getEventPoster(int eventId) async {
    Map<String, dynamic> params = {
      'eventId': eventId,
    };
    Response<dynamic> res = await Client.post('/event/getEventPoster', params);

    return res;
  }

  static Future<Response> getActivityByEvent() async {
  }
}
