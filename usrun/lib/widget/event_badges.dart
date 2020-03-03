import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';

class EventBadges extends StatelessWidget {
  final badgeImageSize = R.appRatio.appEventBadgeSize.roundToDouble();

  final String labelTitle;
  final bool enableLabelShadow;
  final List items;
  final bool enableScrollBackgroundColor;
  final Function pressItemFuction;

  /*
    Structure of the "items" variable: 
    [
      {
        "eventID": "0",                 
        "badgeImageURL": "https://..."
      },
      ...
    ]
  */

  EventBadges({
    this.labelTitle = "",
    this.enableLabelShadow = true,
    @required this.items,
    this.enableScrollBackgroundColor = true,
    this.pressItemFuction,
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
            height: R.appRatio.appHeight100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: this.items.length,
              itemBuilder: (BuildContext ctxt, int index) {
                String eventID = this.items[index]['eventID'];
                String badgeImageURL = this.items[index]['badgeImageURL'];

                return Container(
                  padding: EdgeInsets.only(
                    left: R.appRatio.appSpacing15,
                    right: (index == this.items.length - 1
                        ? R.appRatio.appSpacing15
                        : 0),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (this.pressItemFuction != null) {
                        this.pressItemFuction(eventID);
                      }
                    },
                    child: Center(
                      child: FadeInImage.assetNetwork(
                        placeholder: R.images.smallDefaultImage,
                        image: badgeImageURL,
                        height: this.badgeImageSize,
                        width: this.badgeImageSize,
                        fit: BoxFit.cover,
                        fadeInDuration: new Duration(milliseconds: 100),
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
