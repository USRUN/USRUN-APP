import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/ui_button.dart';

class FollowerFollowingList extends StatelessWidget {
  final String labelTitle;
  final bool enableLabelShadow;
  final String subTitle;
  final bool enableSubtitleShadow;
  final List items;
  final bool enableScrollBackgroundColor;
  final Function pressFollowFuction;
  final Function pressUnfollowFuction;
  final Function pressProfileFunction;
  final bool isFollowingList;
  final bool enableFFButton;
  
  // Define configurations for splitting item list
  static List _newItemList = [];
  static bool _enableListWithTwoRows = false;
  static int _numberToSplit = R.constants.numberToSplitFFList;
  static int _endPositionOfFirstList = 0;

  /*
    Structure of the "items" variable: 
    [
      {
        "userCode": "0",
        "avatarImageURL": "https://...",    [This must be value of HTTP LINK]
        "supportImageURL": "https://...",   [This must be value of HTTP LINK]
        "fullName": "Trần Kiến Quốc",
        "cityName": "Ho Chi Minh",
      },
      ...
    ]
  */

  FollowerFollowingList({
    this.labelTitle = "",
    this.enableLabelShadow = true,
    this.subTitle = "",
    this.enableSubtitleShadow = true,
    @required this.items,
    this.enableScrollBackgroundColor = true,
    this.pressFollowFuction(usercode),
    this.pressUnfollowFuction(usercode),
    this.pressProfileFunction(usercode),
    this.isFollowingList = true,
    this.enableFFButton = true,
  });

  void _splitItemList() {
    if (this.items.length > _numberToSplit) {
      _enableListWithTwoRows = true;
      _endPositionOfFirstList = (this.items.length / 2).round();
      _newItemList.add(this.items.sublist(0, _endPositionOfFirstList));
      _newItemList
          .add(this.items.sublist(_endPositionOfFirstList, this.items.length));
    } else {
      _newItemList.add(this.items);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Split item list
    this._splitItemList();
    
    // Render everything
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          (this.labelTitle.length != 0
              ? Container(
                  padding: EdgeInsets.only(
                    left: R.appRatio.appSpacing15,
                    bottom: (this.subTitle.length != 0
                        ? R.appRatio.appSpacing5
                        : R.appRatio.appSpacing15),
                  ),
                  child: Text(
                    this.labelTitle,
                    style: (this.enableLabelShadow
                        ? R.styles.shadowLabelStyle
                        : R.styles.labelStyle),
                  ),
                )
              : Container()),
          (this.subTitle.length != 0
              ? Container(
                  padding: EdgeInsets.only(
                    left: R.appRatio.appSpacing15,
                    bottom: R.appRatio.appSpacing15,
                  ),
                  child: Text(
                    this.subTitle,
                    style: (this.enableLabelShadow
                        ? R.styles.shadowSubTitleStyle
                        : R.styles.subTitleStyle),
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
                : (_enableListWithTwoRows
                    ? (this.enableFFButton
                        ? R.appRatio.appHeight200 + R.appRatio.appHeight200
                        : R.appRatio.appHeight160 + R.appRatio.appHeight160)
                    : (this.enableFFButton
                        ? R.appRatio.appHeight200
                        : R.appRatio.appHeight160))),
            padding: (_enableListWithTwoRows
                ? EdgeInsets.only(
                    top: R.appRatio.appSpacing10,
                    bottom: R.appRatio.appSpacing10,
                  )
                : null),
            child: (this._isEmptyList()
                ? this._buildEmptyList()
                : (_enableListWithTwoRows
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: this._buildFFList(_newItemList[0]),
                            ),
                            Expanded(
                              child: this._buildFFList(_newItemList[1]),
                            ),
                          ],
                        ),
                      )
                    : this._buildFFList(_newItemList[0]))),
          ),
        ],
      ),
    );
  }

  bool _isEmptyList() {
    return ((this.items == null || this.items.length == 0) ? true : false);
  }

  Widget _buildEmptyList() {
    String systemNoti = "";

    if (this.isFollowingList) {
      systemNoti =
          "USRUN: Find someone and follow them to know what happening around you.";
    } else {
      systemNoti = "USRUN: Be active and passionate, everyone will follow you.";
    }

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

  Widget _buildFFList(List element) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: element.length,
      itemBuilder: (BuildContext ctxt, int index) {
        String userCode = element[index]['userCode'];
        String avatarImageURL = element[index]['avatarImageURL'];
        String supportImageURL = element[index]['supportImageURL'];
        String fullName = element[index]['fullName'];
        String cityName = element[index]['cityName'];

        return Container(
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing15,
            right:
                (index == element.length - 1 ? R.appRatio.appSpacing15 : 0),
          ),
          child: Center(
            child: Container(
              width: R.appRatio.appWidth120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Avatar
                  AvatarView(
                    avatarImageURL: avatarImageURL,
                    avatarImageSize: R.appRatio.appAvatarSize80,
                    enableSquareAvatarImage: false,
                    supportImageURL: supportImageURL,
                    pressAvatarImage: () {
                      if (this.pressProfileFunction != null) {
                        this.pressProfileFunction(userCode);
                      }
                    },
                  ),
                  SizedBox(
                    height: R.appRatio.appSpacing5,
                  ),
                  // Fullname
                  GestureDetector(
                    onTap: () {
                      if (this.pressProfileFunction != null) {
                        this.pressProfileFunction(userCode);
                      }
                    },
                    child: Text(
                      fullName,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: R.appRatio.appFontSize12,
                        color: R.colors.contentText,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: R.appRatio.appSpacing5,
                  ),
                  // City name
                  GestureDetector(
                    onTap: () {
                      if (this.pressProfileFunction != null) {
                        this.pressProfileFunction(userCode);
                      }
                    },
                    child: Text(
                      cityName,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: R.appRatio.appFontSize12,
                        color: R.colors.contentText,
                      ),
                    ),
                  ),
                  (this.enableFFButton
                      ? SizedBox(
                          height: R.appRatio.appSpacing10,
                        )
                      : Container()),
                  // Follower & Following button (FFButon)
                  (this.enableFFButton
                      ? (this.isFollowingList
                          ? UIButton(
                              text: "Unfollow",
                              textColor: R.colors.unfollowButtonColor,
                              textSize: R.appRatio.appFontSize12,
                              radius: 0,
                              width: R.appRatio.appWidth80,
                              height: R.appRatio.appHeight30,
                              enableShadow: false,
                              border: Border.all(
                                width: 1,
                                color: R.colors.unfollowButtonColor,
                              ),
                              onTap: () {
                                if (this.pressUnfollowFuction != null) {
                                  this.pressUnfollowFuction(userCode);
                                }
                              },
                            )
                          : UIButton(
                              text: "Follow",
                              textColor: R.colors.majorOrange,
                              textSize: R.appRatio.appFontSize12,
                              radius: 0,
                              width: R.appRatio.appWidth80,
                              height: R.appRatio.appHeight30,
                              enableShadow: false,
                              border: Border.all(
                                width: 1,
                                color: R.colors.majorOrange,
                              ),
                              onTap: () {
                                if (this.pressFollowFuction != null) {
                                  this.pressFollowFuction(userCode);
                                }
                              },
                            ))
                      : Container()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
