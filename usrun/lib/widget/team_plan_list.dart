import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/util/image_cache_manager.dart';

class _TeamPlanItem extends StatelessWidget {
  final String planID;
  final String planName;
  final String dateTime;
  final bool isFinished;
  final String teamName;
  final String mapImageURL;
  final Function pressItemFuction;

  final double _teamPlanItemWidth = R.appRatio.appWidth220;
  final Color _pinkRedColor = Color(0xFFFF5C4E);
  final double _borderRadius = 5;
  final double _halfBorderRadius = 5 / 2;
  final List<String> _monthName = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JULY",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC"
  ];
  static String _day = "", _month = "", _year = "", _time = "";

  _TeamPlanItem({
    @required this.planID,
    this.planName,
    this.dateTime,
    this.isFinished = false,
    this.teamName,
    this.mapImageURL,
    this.pressItemFuction(planid),
  });

  void _splitDateTimeToAtomic() {
    var splitted = new DateFormat("dd/MM/yyyy hh:mm").parse(this.dateTime);
    _day = splitted.day.toString();
    _month = this._monthName[splitted.month - 1];
    _year = splitted.year.toString();
    _time = (splitted.hour == 0 ? "00" : splitted.hour.toString()) +
        ":" +
        (splitted.minute == 0 ? "00" : splitted.minute.toString());
  }

  @override
  Widget build(BuildContext context) {
    // Split "dateTime" string to atomic elements
    this._splitDateTimeToAtomic();

    // Render everything
    return GestureDetector(
      onTap: () {
        if (this.pressItemFuction != null) {
          this.pressItemFuction(planID);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(this._borderRadius)),
          boxShadow: [
            BoxShadow(
              blurRadius: 2.0,
              offset: Offset(1.0, 1.0),
              color: R.colors.btnShadow,
            ),
          ],
        ),
        width: this._teamPlanItemWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Team name
            Container(
              width: this._teamPlanItemWidth,
              height: R.appRatio.appHeight40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: this._pinkRedColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(this._borderRadius),
                  topRight: Radius.circular(this._borderRadius),
                ),
              ),
              padding: EdgeInsets.only(
                left: R.appRatio.appSpacing5,
                right: R.appRatio.appSpacing5,
              ),
              child: Text(
                this.teamName,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: R.appRatio.appFontSize12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Map
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                ImageCacheManager.getImage(
                  url: this.mapImageURL,
                  width: this._teamPlanItemWidth,
                  height: R.appRatio.appHeight140,
                  fit: BoxFit.cover,
                ),
                (this.isFinished
                    ? Container(
                        child: Image.asset(
                          R.myIcons.finishIcon,
                          fit: BoxFit.cover,
                          width: R.appRatio.appIconSize25,
                          height: R.appRatio.appIconSize25,
                        ),
                      )
                    : Container()),
              ],
            ),
            // Day - Month - Year - Time - Plan name
            Container(
              width: this._teamPlanItemWidth,
              height: R.appRatio.appHeight60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(this._borderRadius),
                  bottomRight: Radius.circular(this._borderRadius),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Month and Day
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: this._pinkRedColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(this._halfBorderRadius)),
                          ),
                          height: R.appRatio.appHeight20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: R.appRatio.appWidth40,
                                color: this._pinkRedColor,
                                alignment: Alignment.center,
                                child: Text(
                                  _month,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: R.appRatio.appFontSize12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                width: R.appRatio.appWidth40,
                                color: Colors.white,
                                child: Text(
                                  _day,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: R.appRatio.appFontSize12,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: R.appRatio.appSpacing5,
                        ),
                        // Year and Time
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: this._pinkRedColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(this._halfBorderRadius)),
                          ),
                          height: R.appRatio.appHeight20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: R.appRatio.appWidth40,
                                color: this._pinkRedColor,
                                alignment: Alignment.center,
                                child: Text(
                                  _year,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: R.appRatio.appFontSize12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                width: R.appRatio.appWidth40,
                                color: Colors.white,
                                child: Text(
                                  _time,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: R.appRatio.appFontSize12,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: R.appRatio.appSpacing10,
                  ),
                  // Plan name
                  Container(
                    width: R.appRatio.appWidth110,
                    height: R.appRatio.appHeight45,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: this._pinkRedColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(this._halfBorderRadius)),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                      left: R.appRatio.appSpacing5,
                      right: R.appRatio.appSpacing5,
                    ),
                    child: Text(
                      this.planName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: R.appRatio.appFontSize12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamPlanList extends StatelessWidget {
  final String labelTitle;
  final bool enableLabelShadow;
  final List items;
  final bool enableScrollBackgroundColor;
  final Function pressItemFuction;

  /*
    Structure of the "items" variable: 
    [
      {
        "planID": "0",
        "planName": "Time to train, get high friends, oh yay!",
        "dateTime": "10/01/2020 18:30",                     [This must have format "dd/MM/yyyy HH:mm"]
        "isFinished": true,
        "teamName": "Trường Đại học Khoa học Tự nhiên",
        "mapImageURL": "https://..."                        [This must be value of HTTP LINK]
      },
      ...
    ]
  */

  TeamPlanList({
    this.labelTitle = "",
    this.enableLabelShadow = true,
    @required this.items,
    this.enableScrollBackgroundColor = true,
    this.pressItemFuction(planid),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          (this.labelTitle.length != 0
              ? Container(
                  padding: EdgeInsets.only(
                    left: R.appRatio.appSpacing15,
                    bottom: R.appRatio.appSpacing15,
                  ),
                  child: Text(
                    this.labelTitle,
                    style: (this.enableLabelShadow
                        ? R.styles.shadowLabelStyle
                        : R.styles.labelStyle),
                  ),
                )
              : Container()),
          Container(
            color: (this.enableScrollBackgroundColor
                ? R.colors.sectionBackgroundLayer
                : R.colors.appBackground),
            width: R.appRatio.deviceWidth,
            height: (this._isEmptyList()
                ? R.appRatio.appHeight100
                : R.appRatio.appHeight280),
            child: (this._isEmptyList()
                ? this._buildEmptyList()
                : this._buildTeamPlanList()),
          ),
        ],
      ),
    );
  }

  bool _isEmptyList() {
    return ((this.items == null || this.items.length == 0) ? true : false);
  }

  Widget _buildEmptyList() {
    String systemNoti =
        "USRUN: You can only join a team plan when you become a member of the teams";

    return Center(
      child: Container(
        padding: EdgeInsets.only(
          left: R.appRatio.appSpacing25,
          right: R.appRatio.appSpacing25,
        ),
        child: Text(
          systemNoti,
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: R.colors.contentText,
            fontSize: R.appRatio.appFontSize14,
          ),
        ),
      ),
    );
  }

  Widget _buildTeamPlanList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: this.items.length,
      itemBuilder: (BuildContext ctxt, int index) {
        String planID = this.items[index]['planID'];
        String planName = this.items[index]['planName'];
        String dateTime = this.items[index]['dateTime'];
        bool isFinished = this.items[index]['isFinished'];
        String teamName = this.items[index]['teamName'];
        String mapImageURL = this.items[index]['mapImageURL'];

        return Container(
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing15,
            right:
                (index == this.items.length - 1 ? R.appRatio.appSpacing15 : 0),
          ),
          child: Center(
            child: _TeamPlanItem(
              planID: planID,
              dateTime: dateTime,
              planName: planName,
              isFinished: isFinished,
              teamName: teamName,
              mapImageURL: mapImageURL,
              pressItemFuction: (planid) {
                print("This is team plan with id $planid");
              },
            ),
          ),
        );
      },
    );
  }
}
