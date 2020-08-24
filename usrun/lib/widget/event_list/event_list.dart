import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:intl/intl.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/util/image_cache_manager.dart';

import 'event_item.dart';

class EventList extends StatelessWidget {
  final String labelTitle;
  final bool enableLabelShadow;
  final List<Event> items;
  final bool enableScrollBackgroundColor;
  final void Function(Event data) pressItemFunction;
  final VoidCallback loadMoreFunction;

  final double _eventItemWidth = R.appRatio.appWidth160;

  EventList({
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
                : R.appRatio.appHeight200),
            child: (this._isEmptyList()
                ? this._buildEmptyList()
                : this._buildEventList()),
          ),
        ],
      ),
    );
  }

  bool _isEmptyList() {
    return ((this.items == null || this.items.length == 0) ? true : false);
  }

  Widget _buildEmptyList() {
    String systemNoti = R.strings.usrunEventListMessage;

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
            fontSize: R.appRatio.appFontSize16,
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: this.items.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == this.items.length - 1 && this.loadMoreFunction != null) {
          this.loadMoreFunction();
        }

        String name = this.items[index].eventName;
        String athleteQuantity = NumberFormat("#,##0", "en_US")
                .format(this.items[index].totalParticipant) +
            " athletes";
        bool isFinished = this.items[index].status==EventStatus.Ended;
        String bannerImageURL = this.items[index].banner;

        return Container(
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing15,
            right:
                (index == this.items.length - 1 ? R.appRatio.appSpacing15 : 0),
          ),
          child: Center(
            child: Container(
              width: this._eventItemWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Banner and isFinished
                  GestureDetector(
                    onTap: () {
                      if (this.pressItemFunction != null) {
                        this.pressItemFunction(this.items[index]);
                      }
                    },
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        Container(
                          width: this._eventItemWidth,
                          height: R.appRatio.appHeight120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2.0,
                                offset: Offset(1.0, 1.0),
                                color: R.colors.btnShadow,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: ImageCacheManager.getImage(
                              url: bannerImageURL,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        (isFinished
                            ? Container(
                                padding: EdgeInsets.only(
                                  left: R.appRatio.appSpacing5,
                                ),
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
                  ),
                  SizedBox(
                    height: R.appRatio.appSpacing10,
                  ),
                  // Event name
                  GestureDetector(
                    onTap: () {
                      if (this.pressItemFunction != null) {
                        this.pressItemFunction(this.items[index]);
                      }
                    },
                    child: Text(
                      name,
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
                  // Athlete quantity
                  GestureDetector(
                    onTap: () {
                      if (this.pressItemFunction != null) {
                        this.pressItemFunction(this.items[index]);
                      }
                    },
                    child: Text(
                      athleteQuantity,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: R.appRatio.appFontSize12,
                        color: R.colors.contentText,
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
