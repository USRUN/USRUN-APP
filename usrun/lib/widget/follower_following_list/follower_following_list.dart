import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/ui_button.dart';

import 'follower_following_item.dart';

class FollowerFollowingList extends StatelessWidget {
  final String labelTitle;

  final String subTitle;
  final bool enableSubtitleShadow;
  final List<FollowerFollowingItem> items;
  final bool enableScrollBackgroundColor;
  final void Function(FollowerFollowingItem item) pressFollowFunction;
  final void Function(FollowerFollowingItem item) pressUnfollowFunction;
  final void Function(FollowerFollowingItem item) pressProfileFunction;
  final bool isFollowingList;
  final bool enableFFButton;
  final VoidCallback loadMoreFunction;

  // Define configurations for splitting item list
  static List<List<FollowerFollowingItem>> _newItemList = [];
  static bool _enableSplitListToTwo = false;
  static int _numberToSplit = R.constants.numberToSplitFFList;
  static int _endPositionOfFirstList = 0;

  FollowerFollowingList({
    this.labelTitle = "",
    this.subTitle = "",
    this.enableSubtitleShadow = true,
    @required this.items,
    this.enableScrollBackgroundColor = true,
    this.pressFollowFunction(data),
    this.pressUnfollowFunction(data),
    this.pressProfileFunction(data),
    this.isFollowingList = true,
    this.enableFFButton = true,
    this.loadMoreFunction,
  });

  void _splitItemList() {
    if (this.items.length > _numberToSplit) {
      _enableSplitListToTwo = true;
      _endPositionOfFirstList = (this.items.length / 2).round();
      _newItemList.add(this.items.sublist(0, _endPositionOfFirstList));
      _newItemList
          .add(this.items.sublist(_endPositionOfFirstList, this.items.length));
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
                    style: R.styles.labelStyle,
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
                    style: R.styles.labelStyle,
                  ),
                )
              : Container()),
          Container(
            color: (this.enableScrollBackgroundColor
                ? R.colors.sectionBackgroundLayer
                : R.colors.appBackground),
            width: R.appRatio.deviceWidth,
            padding: EdgeInsets.only(
              top: R.appRatio.appSpacing10,
              bottom: R.appRatio.appSpacing10,
            ),
            child: (this._isEmptyList()
                ? this._buildEmptyList()
                : (_enableSplitListToTwo
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            this._buildFFList(
                              _newItemList[0],
                              canLoadMore: false,
                            ),
                            SizedBox(height: 5),
                            this._buildFFList(
                              _newItemList[1],
                              canLoadMore: true,
                            ),
                          ],
                        ),
                      )
                    : this._buildFFList(
                        this.items,
                        canLoadMore: true,
                      ))),
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
      systemNoti = R.strings.usrunFollowingListMessage;
    } else {
      systemNoti = R.strings.usrunFollowedListMessage;
    }

    return Container(
      height: R.appRatio.appHeight60,
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        left: R.appRatio.appSpacing25,
        right: R.appRatio.appSpacing25,
      ),
      child: Text(
        systemNoti,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: R.colors.contentText,
          fontSize: R.appRatio.appFontSize16,
        ),
      ),
    );
  }

  Widget _buildFFList(List<FollowerFollowingItem> element,
      {bool canLoadMore: false}) {
    Widget listWidget = ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: element.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == element.length - 1 &&
            this.loadMoreFunction != null &&
            canLoadMore) {
          this.loadMoreFunction();
        }

        String avatarImageURL = element[index].avatarImageURL;
        String supportImageURL = element[index].supportImageURL;
        String fullName = element[index].fullName;
        String cityName = element[index].cityName;

        return Container(
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing15,
            right: (index == element.length - 1 ? R.appRatio.appSpacing15 : 0),
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
                        this.pressProfileFunction(element[index]);
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
                        this.pressProfileFunction(element[index]);
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
                        this.pressProfileFunction(element[index]);
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
                              text: R.strings.unFollow,
                              textColor: R.colors.grayButtonColor,
                              textSize: R.appRatio.appFontSize12,
                              radius: 0,
                              width: R.appRatio.appWidth80,
                              height: R.appRatio.appHeight30,
                              enableShadow: false,
                              border: Border.all(
                                width: 1,
                                color: R.colors.grayButtonColor,
                              ),
                              onTap: () {
                                if (this.pressUnfollowFunction != null) {
                                  this.pressUnfollowFunction(element[index]);
                                }
                              },
                            )
                          : UIButton(
                              text: R.strings.follow,
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
                                if (this.pressFollowFunction != null) {
                                  this.pressFollowFunction(element[index]);
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

    return Container(
      constraints: BoxConstraints(
        maxHeight: (this.enableFFButton
            ? R.appRatio.appHeight190
            : R.appRatio.appHeight140),
      ),
      child: listWidget,
    );
  }
}
