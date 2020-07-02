class TeamMemberItem {
  String avatarImageURL;
  String supportImageURL;
  String name;
  String location;
  bool isFollowing;

  TeamMemberItem({
    this.avatarImageURL = "",
    this.supportImageURL = "",
    this.name = "",
    this.location = "",
    this.isFollowing = false,
  }) : assert(avatarImageURL != null &&
            supportImageURL != null &&
            name != null &&
            location != null &&
            isFollowing != null);
}
