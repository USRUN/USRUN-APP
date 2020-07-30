
import 'package:usrun/core/net/client.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/model/response.dart';

class EventManager{

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

}