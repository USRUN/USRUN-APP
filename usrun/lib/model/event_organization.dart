import 'package:usrun/core/define.dart';
import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/util/reflector.dart';

@reflector
class EventOrganization with MapperObject {
  String name;
  String avatar;

  EventOrganization({
    this.name,
    this.avatar,
  });
}
