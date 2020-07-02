class TeamRankItem {
  String avatarImageURL;
  String name;
  double distance;

  TeamRankItem({
    this.avatarImageURL = "",
    this.name = "",
    this.distance = 0.0,
  }) : assert(avatarImageURL != null &&
            name != null &&
            distance != null &&
            distance >= 0.0);
}
