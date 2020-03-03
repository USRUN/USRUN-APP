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
  final bool isFollowingList;
  final bool enableFFButton;

  /*
    Structure of the "items" variable: 
    [
      {
        "userCode": "0",
        "avatarImageURL": "https://...",
        "supportImageURL": "https://...",
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
    this.pressFollowFuction(string),
    this.pressUnfollowFuction(string),
    this.isFollowingList = true,
    this.enableFFButton = true,
  });

  void _directToAthleteProfile(String userCode) {
    // TODO: Function for directing to this athlete's profile
    print("Directing to this athlete's profile with user code $userCode");
  }

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
            height: (this.enableFFButton
                ? R.appRatio.appHeight190
                : R.appRatio.appHeight150),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: this.items.length,
              itemBuilder: (BuildContext ctxt, int index) {
                String userCode = this.items[index]['userCode'];
                String avatarImageURL = this.items[index]['avatarImageURL'];
                String supportImageURL = this.items[index]['supportImageURL'];
                String fullName = this.items[index]['fullName'];
                String cityName = this.items[index]['cityName'];

                return Container(
                  padding: EdgeInsets.only(
                    left: R.appRatio.appSpacing15,
                    right: (index == this.items.length - 1
                        ? R.appRatio.appSpacing15
                        : 0),
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
                              this._directToAthleteProfile(userCode);
                            },
                          ),
                          SizedBox(
                            height: R.appRatio.appSpacing5,
                          ),
                          // Fullname
                          GestureDetector(
                            onTap: () {
                              this._directToAthleteProfile(userCode);
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
                              this._directToAthleteProfile(userCode);
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
            ),
          ),
        ],
      ),
    );
  }
}
