import 'package:usrun/model/team.dart';

class TeamItem {
  dynamic value;
  int teamId;
  String name;
  int athleteQuantity;
  String avatarImageURL;
  String supportImageURL;
  String bannerImageURL;
  int location;
  int teamMemberType;
  bool verificationStatus;

  TeamItem({
    this.value,
    this.name = "",
    this.athleteQuantity = 0,
    this.avatarImageURL = "",
    this.supportImageURL = "",
    this.bannerImageURL = "",
  }) : assert(avatarImageURL != null &&
            bannerImageURL != null &&
            supportImageURL != null &&
            name != null &&
            athleteQuantity != null &&
            athleteQuantity >= 0);

  TeamItem.from(Team t){
    teamId = t.id;
    name = t.teamName;
    athleteQuantity = t.totalMember;
    avatarImageURL = t.thumbnail;
    supportImageURL = null;
    bannerImageURL = t.banner;
    location = t.province;
    teamMemberType = t.teamMemberType;
    verificationStatus = t.verified;
  }
}
