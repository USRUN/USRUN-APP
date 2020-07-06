import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/widget/event_badge_list/event_badge_item.dart';

class EventBadgeList extends StatelessWidget {
  final String labelTitle;
  final bool enableLabelShadow;
  final List<EventBadgeItem> items;
  final bool enableScrollBackgroundColor;
  final void Function(EventBadgeItem data) pressItemFunction;
  final VoidCallback loadMoreFunction;

  final _imageSize = R.appRatio.appEventBadgeSize;

  EventBadgeList({
    this.labelTitle = "",
    this.enableLabelShadow = true,
    @required this.items,
    this.enableScrollBackgroundColor = true,
    this.pressItemFunction(data),
    this.loadMoreFunction,
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
      itemBuilder: (BuildContext context, int index) {
        if (index == this.items.length - 1 && this.loadMoreFunction != null) {
          this.loadMoreFunction();
        }

        String imageURL = this.items[index].imageURL;

        return Container(
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing15,
            right:
                (index == this.items.length - 1 ? R.appRatio.appSpacing15 : 0),
          ),
          child: GestureDetector(
            onTap: () {
              if (this.pressItemFunction != null) {
                this.pressItemFunction(this.items[index]);
              }
            },
            child: Center(
              child: ImageCacheManager.getImage(
                url: imageURL,
                fit: BoxFit.cover,
                height: this._imageSize,
                width: this._imageSize,
              ),
            ),
          ),
        );
      },
    );
  }
}
