import 'package:usrun/core/define.dart';
import 'package:usrun/model/user.dart';

class TeamMemberItem {
  String avatarImageURL;
  String supportImageURL;
  String name;
  String location;
  bool isFollowing;
  int userId;
  TeamMemberType teamMemberType;

  TeamMemberItem({
    this.avatarImageURL = "",
    this.supportImageURL = "",
    this.name = "",
    this.location = "",
    this.isFollowing = false,
    this.teamMemberType = TeamMemberType.Guest,
    this.userId = -1
  }) : assert(
            avatarImageURL != null &&
            supportImageURL != null &&
            name != null &&
            location != null &&
            isFollowing != null);
}
