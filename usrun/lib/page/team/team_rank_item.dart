import 'package:usrun/model/team_leaderboard.dart';
import 'package:usrun/util/reflector.dart';

@reflector
class TeamRankItem {
  int userId;
  String avatarImageURL;
  String name;
  int distance;

  TeamRankItem({
    this.userId,
    this.avatarImageURL = "",
    this.name = "",
    this.distance = 0,
  }) : assert(avatarImageURL != null &&
            name != null &&
            distance != null &&
            distance >= 0.0);

  TeamRankItem.from(TeamLeaderboard t) {
    this.userId = t.userId;
    this.avatarImageURL = t.avatar;
    this.name = t.displayName;
    this.distance = t.totalDistance;
  }
}
