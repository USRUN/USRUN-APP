import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:intl/intl.dart';
import 'package:usrun/widget/avatar_view.dart';

class TeamList extends StatelessWidget {
  final String labelTitle;
  final bool enableLabelShadow;
  List items;
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
    this.pressItemFuction(teamId),
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
            padding: EdgeInsets.only(
              top: R.appRatio.appSpacing10,
              bottom: R.appRatio.appSpacing10,
            ),
            child: (this._isEmptyList()
                ? this._buildEmptyList()
                : (this.enableSplitListToTwo
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            this._buildTeamList(_newItemList[0]),
                            SizedBox(height: 5),
                            this._buildTeamList(_newItemList[1]),
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

    return Container(
      height: R.appRatio.appHeight60,
      alignment: Alignment.center,
      margin: EdgeInsets.only(
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
    );
  }

  Widget _buildTeamList(List element) {
    Widget listWidget = ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: element.length,
      itemBuilder: (BuildContext context, int index) {
        String id = element[index]['id'];
        String name = element[index]['name'];
        String athleteQuantity = NumberFormat("#,##0", "en_US")
            .format(element[index]['athleteQuantity']);
        String avatarImageURL = element[index]['avatarImageURL'];
        String supportImageURL = element[index]['supportImageURL'];

        return Container(
          margin: EdgeInsets.only(
            left: R.appRatio.appSpacing15,
            right: R.appRatio.appSpacing15,
          ),
          // Width of this container equals width (size) of avatar image
          width: this._avatarSize,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
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
                  constraints: BoxConstraints(
                    maxHeight: R.appRatio.appHeight50,
                  ),
                  child: Text(
                    name,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
        );
      },
    );

    return Container(
      constraints: BoxConstraints(
        maxHeight: R.appRatio.appHeight170,
      ),
      child: listWidget,
    );
  }
}
