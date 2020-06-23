import 'package:usrun/core/define.dart';

import 'package:usrun/util/reflector.dart';

import 'package:usrun/model/mapper_object.dart';


@reflector
class TeamMember extends MapperObject {
  // TODO: NOTE DOWN teamMemberType
  int teamId;
  int userId;
  int teamMemberType;
  DateTime addTime;
}