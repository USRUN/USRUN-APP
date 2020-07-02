class FollowerFollowingItem {
  dynamic value;
  String avatarImageURL;
  String supportImageURL;
  String fullName;
  String cityName;

  FollowerFollowingItem({
    this.value,
    this.avatarImageURL = "",
    this.supportImageURL = "",
    this.fullName = "",
    this.cityName = "",
  }) : assert(avatarImageURL != null &&
            supportImageURL != null &&
            fullName != null &&
            cityName != null);
}
