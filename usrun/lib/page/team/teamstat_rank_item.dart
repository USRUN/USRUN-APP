import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/util/reflector.dart';

@reflector
class TeamStatRankItem extends MapperObject{
  int teamId;
  int rank;
  String avatar;
  String name;
  int distance;

  TeamStatRankItem({
    teamId = -1,
    avatar = "",
    rank = -1,
    name = "",
    distance = -1
  });
}