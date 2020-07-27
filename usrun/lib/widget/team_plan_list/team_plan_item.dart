class TeamPlanItem {
  dynamic value;
  String planName;
  DateTime dateTime;
  bool isFinished;
  String teamName;
  String mapImageURL;

  TeamPlanItem({
    this.value,
    this.planName = "",
    this.dateTime,
    this.isFinished = false,
    this.teamName = "",
    this.mapImageURL = "",
  }) : assert(planName != null &&
            dateTime != null &&
            isFinished != null &&
            teamName != null &&
            mapImageURL != null);
}
