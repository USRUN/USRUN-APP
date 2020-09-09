import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/util/image_cache_manager.dart';

class _ActivityLine extends StatelessWidget {
  final double lineHeight;
  final double lineWidth;

  _ActivityLine({
    this.lineHeight = 250,
    this.lineWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    double _firstCircleWidth = (lineWidth * 5).roundToDouble();
    double _secondCircleWidth = (lineWidth * 3.5).roundToDouble();

    return Container(
      width: _firstCircleWidth,
      height: this.lineHeight,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            width: this.lineWidth,
            height: this.lineHeight,
            color: R.colors.contentText,
          ),
          Container(
            width: _firstCircleWidth,
            height: _firstCircleWidth,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(_firstCircleWidth / 2),
              ),
            ),
            child: Container(
              width: _secondCircleWidth,
              height: _secondCircleWidth,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(_secondCircleWidth / 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityContent extends StatelessWidget {
  final String activityID;
  final String dateTime;
  final double distance;
  final bool isKM;
  final String title;
  final String time;
  final String pace;
  final String elevation;
  final String calories;
  final bool isLoved;
  final int loveNumber;
  final Function pressActivityFunction;
  final Function pressLoveFunction;
  final Function pressCommentFunction;
  final Function pressShareFunction;
  final Function pressInteractionFunction;

  // TODO: Change _boxHeight, _bottomHeightSmallRightBox
  // (Turn off "love-comment-share-totalloves" feature)
  static double _boxHeight =
      R.appRatio.appHeight190; // R.appRatio.appHeight210;
  static Color _boxColor = Color(0xFFFFE4CF);
  static Color _pathIconColor = Color(0xFFE6CDBB);
  static double _boxRadius = 10;
  static double _bigBoxWidth = (R.appRatio.deviceWidth >= 360
      ? R.appRatio.appWidth350
      : R.appRatio.appWidth290);
  static double _smallLeftBoxWidth = (R.appRatio.deviceWidth >= 360
      ? R.appRatio.appWidth110
      : R.appRatio.appWidth90);
  static double _smallRightBoxWidth = _bigBoxWidth - _smallLeftBoxWidth;
  static double _bottomHeightSmallRightBox = 0; // R.appRatio.appHeight40;
  static double _topHeightSmallRightBox =
      _boxHeight - _bottomHeightSmallRightBox;
  static double _statsInfoWidth = (R.appRatio.deviceWidth >= 360
      ? R.appRatio.appWidth100
      : R.appRatio.appWidth80);

  _ActivityContent({
    @required this.activityID,
    this.dateTime = "N/A",
    this.distance = 0.0,
    this.isKM = true,
    this.title = "N/A",
    this.time = "N/A",
    this.pace = "N/A",
    this.elevation = "N/A",
    this.calories = "N/A",
    this.isLoved = false,
    this.loveNumber = 0,
    this.pressActivityFunction(string),
    this.pressLoveFunction(string),
    this.pressCommentFunction(string),
    this.pressShareFunction(string),
    this.pressInteractionFunction(string),
  });

  @override
  Widget build(BuildContext context) {
    String _formattedDistance =
        NumberFormat("#,##0.00", "en_US").format(this.distance);
    String _formattedLoveNumber = '${this.loveNumber}' + " love(s)";

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Datetime
        Text(
          this.dateTime,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: R.appRatio.appFontSize16 - 1,
            color: R.colors.contentText,
          ),
        ),
        SizedBox(
          height: R.appRatio.appSpacing10,
        ),
        // Distance & other info
        Container(
          width: _bigBoxWidth,
          height: _boxHeight,
          decoration: BoxDecoration(
            color: _boxColor,
            borderRadius: BorderRadius.all(Radius.circular(_boxRadius)),
            boxShadow: [R.styles.boxShadowRB],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Distance
              GestureDetector(
                onTap: () {
                  if (this.pressActivityFunction != null) {
                    this.pressActivityFunction(this.activityID);
                  }
                },
                child: Container(
                  width: _smallLeftBoxWidth,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: R.colors.verticalUiGradient,
                    // gradient: R.colors.uiGradient,
                    // color: R.colors.majorOrange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(_boxRadius),
                      bottomLeft: Radius.circular(_boxRadius),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FittedBox(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: R.appRatio.appSpacing10,
                            right: R.appRatio.appSpacing10,
                          ),
                          child: Text(
                            _formattedDistance,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: R.appRatio.appFontSize36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        (this.isKM ? "KM" : "M"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: R.appRatio.appFontSize16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Other info
              Container(
                width: _smallRightBoxWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(_boxRadius),
                    bottomRight: Radius.circular(_boxRadius),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Title - Time - Pace - Elevation - Calories
                    GestureDetector(
                      onTap: () {
                        if (this.pressActivityFunction != null) {
                          this.pressActivityFunction(this.activityID);
                        }
                      },
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: _smallRightBoxWidth,
                            height: _topHeightSmallRightBox - 1.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(_boxRadius),
                              ),
                            ),
                            child: ImageCacheManager.getImage(
                              url: R.myIcons.pathIcon,
                              height: R.appRatio.appHeight110,
                              width: R.appRatio.appWidth181,
                              fit: BoxFit.contain,
                              color: _pathIconColor,
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: R.appRatio.appSpacing10,
                              ),
                              // Title
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: R.appRatio.appSpacing10,
                                  ),
                                  ImageCacheManager.getImage(
                                    url: R.myIcons.blackRunnerIcon,
                                    width: R.appRatio.appIconSize25,
                                    height: R.appRatio.appIconSize25,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    width: R.appRatio.appSpacing5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      this.title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: R.appRatio.appFontSize16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: R.appRatio.appSpacing5,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: R.appRatio.appSpacing10,
                              ),
                              // Time - Pace - Elevation - Calories
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: _statsInfoWidth,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Time",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: R.appRatio.appFontSize16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: R.appRatio.appSpacing10,
                                        ),
                                        Text(
                                          "Pace",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: R.appRatio.appFontSize16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: R.appRatio.appSpacing10,
                                        ),
                                        Text(
                                          "Elev.Gain",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: R.appRatio.appFontSize16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: R.appRatio.appSpacing10,
                                        ),
                                        Text(
                                          "Calories",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: R.appRatio.appFontSize16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: _statsInfoWidth,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          this.time,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: R.appRatio.appFontSize16,
                                            color: R.colors.majorOrange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: R.appRatio.appSpacing10,
                                        ),
                                        Text(
                                          this.pace,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: R.appRatio.appFontSize16,
                                            color: R.colors.majorOrange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: R.appRatio.appSpacing10,
                                        ),
                                        Text(
                                          this.elevation,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: R.appRatio.appFontSize16,
                                            color: R.colors.majorOrange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: R.appRatio.appSpacing10,
                                        ),
                                        Text(
                                          this.calories,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: R.appRatio.appFontSize16,
                                            color: R.colors.majorOrange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Horizontal divider
                    Container(
                      height: 1,
                      width: _smallRightBoxWidth,
                      color: _pathIconColor,
                    ),
                    // Love - Comment - Share - Love number
//                    TODO: Turn off this big feature
//                    Container(
//                      width: _smallRightBoxWidth,
//                      height: _bottomHeightSmallRightBox,
//                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.only(
//                          bottomRight: Radius.circular(_boxRadius),
//                        ),
//                      ),
//                      padding: EdgeInsets.only(
//                        left: R.appRatio.appSpacing5,
//                        right: R.appRatio.appSpacing5,
//                      ),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          // Love
//                          GestureDetector(
//                            onTap: () {
//                              if (this.pressLoveFunction != null) {
//                                this.pressLoveFunction(this.activityID);
//                              }
//                            },
//                            child: ImageCacheManager.getImage(
//                              url: (this.isLoved
//                                  ? R.myIcons.blackBoldLoveIcon
//                                  : R.myIcons.blackLoveIcon),
//                              width: R.appRatio.appIconSize20,
//                              height: R.appRatio.appIconSize20,
//                              fit: BoxFit.contain,
//                            ),
//                          ),
//                          SizedBox(
//                            width: R.appRatio.appSpacing20,
//                          ),
//                          // Comment
//                          GestureDetector(
//                            onTap: () {
//                              if (this.pressCommentFunction != null) {
//                                this.pressCommentFunction(this.activityID);
//                              }
//                            },
//                            child: ImageCacheManager.getImage(
//                              url: R.myIcons.blackCommentIcon,
//                              width: R.appRatio.appIconSize20,
//                              height: R.appRatio.appIconSize20,
//                              fit: BoxFit.contain,
//                            ),
//                          ),
//                          SizedBox(
//                            width: R.appRatio.appSpacing20,
//                          ),
//                          // Share
//                          GestureDetector(
//                            onTap: () {
//                              if (this.pressShareFunction != null) {
//                                this.pressShareFunction(this.activityID);
//                              }
//                            },
//                            child: ImageCacheManager.getImage(
//                              url: R.myIcons.blackShareIcon,
//                              width: R.appRatio.appIconSize20,
//                              height: R.appRatio.appIconSize20,
//                              fit: BoxFit.contain,
//                            ),
//                          ),
//                          SizedBox(
//                            width: R.appRatio.appSpacing20,
//                          ),
//                          // Love number
//                          Expanded(
//                            child: GestureDetector(
//                              onTap: () {
//                                if (this.pressInteractionFunction != null) {
//                                  this.pressInteractionFunction(
//                                      this.activityID);
//                                }
//                              },
//                              child: Text(
//                                _formattedLoveNumber,
//                                textAlign: TextAlign.right,
//                                style: TextStyle(
//                                  fontSize: R.appRatio.appFontSize16,
//                                  color: Colors.black,
//                                ),
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ActivityTimeline extends StatefulWidget {
  final String activityID;
  final String dateTime;
  final double distance;
  final bool isKM;
  final String title;
  final String time;
  final String pace;
  final String elevation;
  final String calories;
  final bool isLoved;
  final int loveNumber;
  final bool enableScrollBackgroundColor;
  final Function pressActivityFunction;
  final Function pressLoveFunction;
  final Function pressCommentFunction;
  final Function pressShareFunction;
  final Function pressInteractionFunction;

  ActivityTimeline({
    @required this.activityID,
    this.dateTime = "N/A",
    this.distance = 0.0,
    this.isKM = true,
    this.title = "N/A",
    this.time = "N/A",
    this.pace = "N/A",
    this.elevation = "N/A",
    this.calories = "N/A",
    this.isLoved = false,
    this.loveNumber = 0,
    this.enableScrollBackgroundColor = false,
    this.pressActivityFunction(string),
    this.pressLoveFunction(string),
    this.pressCommentFunction(string),
    this.pressShareFunction(string),
    this.pressInteractionFunction(string),
  });

  @override
  _ActivityTimelineState createState() => new _ActivityTimelineState();
}

class _ActivityTimelineState extends State<ActivityTimeline> {
  // TODO: Change _boxHeight, _bottomHeightSmallRightBox
  // (Turn off "love-comment-share-totalloves" feature)
  double _lineHeight = R.appRatio.appHeight240; // R.appRatio.appHeight270;
  double _lineWidth = 3;

  bool _isLovedState = false;
  int _loveNumberState = 0;

  @override
  void initState() {
    _isLovedState = widget.isLoved;
    _loveNumberState = widget.loveNumber;
    super.initState();
  }

  void _updateIsLovedState() {
    if (!mounted) return;
    setState(() {
      _isLovedState = !_isLovedState;
    });
  }

  void _setLoveNumber(int value) {
    if (!mounted) return;
    setState(() {
      _loveNumberState = value;
    });
  }

  void _newPressLoveFunction(String actID) {
    widget.pressLoveFunction(actID);

    _updateIsLovedState();

    int _currentLoveNumber = _loveNumberState;
    if (_isLovedState) {
      _currentLoveNumber += 1;
    } else {
      _currentLoveNumber -= 1;
    }
    _setLoveNumber(_currentLoveNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (widget.enableScrollBackgroundColor
          ? R.colors.sectionBackgroundLayer
          : R.colors.appBackground),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _ActivityLine(
            lineHeight: _lineHeight,
            lineWidth: _lineWidth,
          ),
          SizedBox(
            width: R.appRatio.appSpacing10,
          ),
          _ActivityContent(
            activityID: widget.activityID,
            title: widget.title.isEmpty ? R.strings.na : widget.title,
            dateTime: widget.dateTime,
            distance: widget.distance,
            isKM: widget.isKM,
            pace: widget.pace == "-1" ? R.strings.na : widget.pace,
            time: widget.time,
            calories: widget.calories == "-1" ? R.strings.na : widget.calories,
            elevation:
                widget.elevation == "-1" ? R.strings.na : widget.elevation,
            isLoved: _isLovedState,
            loveNumber: _loveNumberState,
            pressActivityFunction: widget.pressActivityFunction,
            pressLoveFunction: (actID) {
              this._newPressLoveFunction(actID);
            },
            pressCommentFunction: widget.pressCommentFunction,
            pressShareFunction: widget.pressShareFunction,
            pressInteractionFunction: widget.pressInteractionFunction,
          ),
        ],
      ),
    );
  }
}
