import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/util/reflector.dart';

@reflector
class EventAthlete with MapperObject {
  int userId;
  String avatar;
  String name;
  int province;

  EventAthlete({
    this.userId,
    this.avatar,
    this.name,
    this.province,
  });
}
