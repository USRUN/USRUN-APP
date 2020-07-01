import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:intl/intl.dart';
import 'package:usrun/model/team.dart';
import 'package:usrun/widget/avatar_view.dart';

class TeamList extends StatelessWidget {
  final String labelTitle;
  final bool enableLabelShadow;
  final List items;
  final bool enableScrollBackgroundColor;
  final bool enableSplitListToTwo;
  final Function pressItemFuction;

  // Define configurations
  final double _avatarSize = R.appRatio.appAvatarSize80;
  static List _newItemList = [];
  static int _endPositionOfFirstList = 0;

  /*
    Structure of the "items" variable: 
    [
      {
        "id": "0",
        "name": "Trường Đại học Khoa học Tự nhiên",
        "athleteQuantity": 44284,
        "avatarImageURL": "https://...",    [This has value of HTTP LINK, or an ASSET]
        "supportImageURL": "https://..."    [This has value of HTTP LINK, or an ASSET, or the NULL]
      },
      ...
    ]
  */

  TeamList({
    this.labelTitle = "",
    this.enableLabelShadow = true,
    this.enableSplitListToTwo = false,
    @required this.items,
    this.enableScrollBackgroundColor = true,
    this.pressItemFuction(teamid),
  });

  void _splitItemList() {
    if (this.enableSplitListToTwo && this.items.length > 1) {
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
                : (this.enableSplitListToTwo
                    ? R.appRatio.appHeight210 + R.appRatio.appHeight200
                    : R.appRatio.appHeight210)),
            padding: (this.enableSplitListToTwo
                ? EdgeInsets.only(
                    top: R.appRatio.appSpacing10,
                    bottom: R.appRatio.appSpacing10,
                  )
                : null),
            child: (this._isEmptyList()
                ? this._buildEmptyList()
                : (this.enableSplitListToTwo
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: this._buildTeamList(_newItemList[0]),
                            ),
                            Expanded(
                              child: this._buildTeamList(_newItemList[1]),
                            ),
                          ],
                        ),
                      )
                    : this._buildTeamList(this.items))),
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
        "USRUN: Let's join various teams to make new friends and challenge events together.";

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

  Widget _buildTeamList(List<Team> element) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: element.length,
      itemBuilder: (BuildContext ctx, int index) {
        int id = element[index].id;
        String name = element[index].teamName;
        String athleteQuantity = NumberFormat("#,##0", "en_US")
            .format((element[index].totalMember));
        String avatarImageURL = element[index].thumbnail;
        String supportImageURL = element[index].thumbnail;

        return Container(
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing15,
            right: R.appRatio.appSpacing15,
          ),
          child: Center(
            child: Container(
              // Width of this container equals width (size) of avatar image
              width: this._avatarSize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Team avatar
                  AvatarView(
                    avatarImageURL: avatarImageURL,
                    avatarImageSize: this._avatarSize,
                    supportImageURL: supportImageURL,
                    enableSquareAvatarImage: true,
                    pressAvatarImage: () {
                      if (this.pressItemFuction != null) {
                        this.pressItemFuction(id);
                      }
                    },
                  ),
                  SizedBox(
                    height: R.appRatio.appSpacing5,
                  ),
                  // Athlete quantity
                  GestureDetector(
                    onTap: () {
                      if (this.pressItemFuction != null) {
                        this.pressItemFuction(id);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          R.myIcons.peopleIconByTheme,
                          fit: BoxFit.cover,
                          width: R.appRatio.appIconSize15,
                          height: R.appRatio.appIconSize15,
                        ),
                        SizedBox(
                          width: R.appRatio.appSpacing5,
                        ),
                        Text(
                          athleteQuantity,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: R.appRatio.appFontSize12,
                            color: R.colors.contentText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: R.appRatio.appSpacing5,
                  ),
                  // Team name
                  GestureDetector(
                    onTap: () {
                      if (this.pressItemFuction != null) {
                        this.pressItemFuction(id);
                      }
                    },
                    child: Container(
                      height: R.appRatio.appHeight60 + 4.0,
                      child: Text(
                        name,
                        maxLines: null,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: R.appRatio.appFontSize12,
                          color: R.colors.contentText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
