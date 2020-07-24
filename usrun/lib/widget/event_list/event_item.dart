class EventItem {
  dynamic value;
  String name;
  int athleteQuantity;
  bool isFinished;
  String bannerImageURL;

  EventItem({
    this.value,
    this.name = "",
    this.athleteQuantity = 0,
    this.isFinished = false,
    this.bannerImageURL = "",
  }) : assert(name != null &&
            athleteQuantity != null &&
            athleteQuantity >= 0 &&
            isFinished != null &&
            bannerImageURL != null);
}
