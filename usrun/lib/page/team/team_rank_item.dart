import 'package:usrun/util/reflector.dart';

@reflector
class TeamRankItem {
  int userId;
  String avatarImageURL;
  String name;
  double distance;

  TeamRankItem({
    this.userId,
    this.avatarImageURL = "",
    this.name = "",
    this.distance = 0.0,
  }) : assert(avatarImageURL != null &&
            name != null &&
            distance != null &&
            distance >= 0.0);
}
