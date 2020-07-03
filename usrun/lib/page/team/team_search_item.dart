class TeamSearchItem {
  String avatarImageURL;
  String supportImageURL;
  String teamName;
  int athleteQuantity;
  String location;

  TeamSearchItem({
    this.avatarImageURL = "",
    this.supportImageURL = "",
    this.teamName = "",
    this.athleteQuantity = 0,
    this.location = "",
  }) : assert(avatarImageURL != null &&
            supportImageURL != null &&
            teamName != null &&
            location != null &&
            athleteQuantity != null &&
            athleteQuantity >= 0);
}
