class EventBadgeItem {
  dynamic value;
  String imageURL;

  EventBadgeItem({
    this.value,
    this.imageURL = "",
  }) : assert(imageURL != null);
}
