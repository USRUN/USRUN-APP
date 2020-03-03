import 'package:flutter/material.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:usrun/core/R.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoList extends StatelessWidget {
  final thumbnailSize = R.appRatio.appThumbnailSize.roundToDouble();

  final String labelTitle;
  final bool enableLabelShadow;
  final List items;
  final bool enableScrollBackgroundColor;

  /*
    Structure of the "items" variable: 
    [
      {
        "thumbnailURL": "https://...",
        "imageURL": "https://..."
      },
      ...
    ]
  */

  PhotoList({
    this.labelTitle = "",
    this.enableLabelShadow = true,
    @required this.items,
    this.enableScrollBackgroundColor = true,
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
            height: R.appRatio.appHeight120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: this.items.length,
              itemBuilder: (BuildContext ctxt, int index) {
                String thumbnailURL = this.items[index]['thumbnailURL'];

                return Container(
                  padding: EdgeInsets.only(
                    left: R.appRatio.appSpacing15,
                    right: (index == this.items.length - 1
                        ? R.appRatio.appSpacing15
                        : 0),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      this._expandPhoto(context, index);
                    },
                    child: Center(
                      child: FadeInImage.assetNetwork(
                        placeholder: R.images.smallDefaultImage,
                        image: thumbnailURL,
                        height: this.thumbnailSize,
                        width: this.thumbnailSize,
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
  final List items;

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
        child: GestureDetector(
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
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final element = widget.items[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(element['imageURL']),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * 1.0,
      maxScale: PhotoViewComputedScale.covered * 2.0,
      heroAttributes: PhotoViewHeroAttributes(tag: index),
    );
  }
}
