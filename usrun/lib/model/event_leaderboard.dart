import 'package:usrun/model/mapper_object.dart';

class EventLeaderboard with MapperObject {
  int itemId;
  String avatar;
  String name;
  int distance;

  EventLeaderboard({
    this.itemId,
    this.avatar,
    this.name,
    this.distance,
  });
}