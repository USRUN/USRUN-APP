import 'package:usrun/core/define.dart';

import 'package:usrun/util/reflector.dart';

import 'package:usrun/model/mapper_object.dart';


@reflector
class TeamMember extends MapperObject {
  //  OWNER(1),
  //  ADMIN(2),
  //  MEMBER(3),
  //  PENDING(4),
  //  BLOCKED(5);
  // GUESS (6);

  int teamId;
  int userId;
  int teamMemberType;
  DateTime addTime;
}