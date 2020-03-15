import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/util/image_cache_manager.dart';

class EventBadgeList extends StatelessWidget {
  final String labelTitle;
  final bool enableLabelShadow;
  final List items;
  final bool enableScrollBackgroundColor;
  final Function pressItemFuction;

  final _badgeImageSize = R.appRatio.appEventBadgeSize;

  /*
    Structure of the "items" variable: 
    [
      {
        "eventID": "0",                 
        "badgeImageURL": "https://..."    [This must be value of HTTP LINK]
      },
      ...
    ]
  */

  EventBadgeList({
    this.labelTitle = "",
    this.enableLabelShadow = true,
    @required this.items,
    this.enableScrollBackgroundColor = true,
    this.pressItemFuction(eventid),
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
                : R.appRatio.appHeight120),
            child: (this._isEmptyList()
                ? this._buildEmptyList()
                : this._buildEventBadges()),
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
        "USRUN: Let's join an event to get your first new badge!";

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

  Widget _buildEventBadges() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: this.items.length,
      itemBuilder: (BuildContext ctxt, int index) {
        String eventID = this.items[index]['eventID'];
        String badgeImageURL = this.items[index]['badgeImageURL'];

        return Container(
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing15,
            right:
                (index == this.items.length - 1 ? R.appRatio.appSpacing15 : 0),
          ),
          child: GestureDetector(
            onTap: () {
              if (this.pressItemFuction != null) {
                this.pressItemFuction(eventID);
              }
            },
            child: Center(
              child: ImageCacheManager.getImage(
                url: badgeImageURL,
                fit: BoxFit.cover,
                height: this._badgeImageSize,
                width: this._badgeImageSize,
              ),
            ),
          ),
        );
      },
    );
  }
}
