import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/util/reflector.dart';

@reflector
class EventLeaderboard with MapperObject {
  int itemId;
  String avatar;
  String name;
  int distance;
  int rank;

  EventLeaderboard({
    this.itemId,
    this.avatar,
    this.name,
    this.distance,
    this.rank,
  });
}