class TeamItem {
  dynamic value;
  String name;
  int athleteQuantity;
  String avatarImageURL;
  String supportImageURL;

  TeamItem({
    this.value,
    this.name = "",
    this.athleteQuantity = 0,
    this.avatarImageURL = "",
    this.supportImageURL = "",
  }) : assert(avatarImageURL != null &&
            supportImageURL != null &&
            name != null &&
            athleteQuantity != null &&
            athleteQuantity >= 0);
}
