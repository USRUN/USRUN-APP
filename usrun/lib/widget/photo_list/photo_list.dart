import 'package:flutter/material.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:usrun/core/R.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/util/validator.dart';
import 'package:usrun/widget/photo_list/photo_item.dart';

class PhotoList extends StatelessWidget {
  final String labelTitle;
  final bool enableLabelShadow;
  final List<PhotoItem> items;
  final bool enableScrollBackgroundColor;

  final double _thumbnailSize = R.appRatio.appPhotoThumbnailSize;

  // Define configurations for splitting item list
  static List<List<PhotoItem>> _newItemList = [];
  static bool _enableListWithTwoRows = false;
  static int _numberToSplit = R.constants.numberToSplitPhotoList;
  static int _endPositionOfFirstList = 0;

  PhotoList({
    this.labelTitle = "",
    this.enableLabelShadow = true,
    @required this.items,
    this.enableScrollBackgroundColor = true,
  });

  void _splitItemList() {
    if (this.items.length > _numberToSplit) {
      _enableListWithTwoRows = true;
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
          (!checkStringNullOrEmpty(this.labelTitle)
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
                : (_enableListWithTwoRows
                    ? R.appRatio.appHeight120 + R.appRatio.appHeight120
                    : R.appRatio.appHeight120)),
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
                              child: this
                                  ._buildPhotoList(context, _newItemList[0], 0),
                            ),
                            Expanded(
                              child: this._buildPhotoList(context,
                                  _newItemList[1], _endPositionOfFirstList),
                            ),
                          ],
                        ),
                      )
                    : this._buildPhotoList(context, this.items, 0))),
          ),
        ],
      ),
    );
  }

  bool _isEmptyList() {
    return ((this.items == null || this.items.length == 0) ? true : false);
  }

  Widget _buildEmptyList() {
    String systemNoti = R.strings.usrunPhotoListMessage;

    return Center(
      child: Container(
        padding: EdgeInsets.only(
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
      ),
    );
  }

  Widget _buildPhotoList(
      BuildContext context, List<PhotoItem> element, int firstIndexOfPhoto) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: element.length,
      itemBuilder: (BuildContext ctxt, int index) {
        String thumbnailURL = element[index].thumbnailURL;

        return Container(
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing15,
            right: (index == element.length - 1 ? R.appRatio.appSpacing15 : 0),
          ),
          child: GestureDetector(
            onTap: () {
              this._expandPhoto(context, index + firstIndexOfPhoto);
            },
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: ImageCacheManager.getImage(
                  url: thumbnailURL,
                  fit: BoxFit.cover,
                  height: this._thumbnailSize,
                  width: this._thumbnailSize,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _expandPhoto(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _GalleryPhotoViewWrapper(
          items: this.items,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          loadingBuilder: (context, event) => Center(
            child: NutsActivityIndicator(
              activeColor: Colors.red,
              inactiveColor: Colors.orange,
              tickCount: 12,
              relativeWidth: 0.8,
              radius: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _GalleryPhotoViewWrapper extends StatefulWidget {
  _GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex,
    @required this.items,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder loadingBuilder;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<PhotoItem> items;

  @override
  State<StatefulWidget> createState() => new _GalleryPhotoViewWrapperState();
}

class _GalleryPhotoViewWrapperState extends State<_GalleryPhotoViewWrapper> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: widget.backgroundDecoration,
          constraints: BoxConstraints.expand(
            height: R.appRatio.deviceHeight,
          ),
          child: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              // Photo
              GestureDetector(
                onVerticalDragEnd: (event) {
                  Navigator.of(context).pop();
                },
                child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: _buildItem,
                  itemCount: widget.items.length,
                  loadingBuilder: widget.loadingBuilder,
                  backgroundDecoration: widget.backgroundDecoration,
                  pageController: widget.pageController,
                  onPageChanged: onPageChanged,
                ),
              ),
              // Back button
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  boxShadow: [R.styles.boxShadowB],
                ),
                margin: EdgeInsets.only(
                  left: 15,
                  top: R.appRatio.statusBarHeight + 15,
                ),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  padding: EdgeInsets.all(0),
                  splashColor: R.colors.lightBlurMajorOrange,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: ImageCacheManager.getImage(
                    url: R.myIcons.appBarBackBtn,
                    color: Colors.black,
                    width: 15,
                    height: 15,
                  ),
                ),
              ),
            ],
          )),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final imageURL = widget.items[index].imageURL;
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(imageURL),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * 1.0,
      maxScale: PhotoViewComputedScale.covered * 2.0,
      heroAttributes: PhotoViewHeroAttributes(tag: index),
    );
  }
}
