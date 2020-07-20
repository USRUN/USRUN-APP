import 'package:flutter/material.dart';
import 'package:usrun/util/image_cache_manager.dart';

class AvatarView extends StatelessWidget {
  final String avatarImageURL;
  final double avatarImageSize;
  final BoxShadow avatarBoxShadow;
  final BoxBorder avatarBoxBorder;
  final bool enableSquareAvatarImage;
  final double avatarSquareWidth;
  final double avatarSquareHeight;
  final double radiusSquareBorder;
  final Function pressAvatarImage;
  final String supportImageURL;

  AvatarView({
    @required this.avatarImageURL,
    this.avatarImageSize = 0.0,
    this.avatarBoxShadow,
    this.avatarBoxBorder,
    this.enableSquareAvatarImage = false,
    this.avatarSquareWidth = 0.0,
    this.avatarSquareHeight = 0.0,
    this.radiusSquareBorder = 5,
    this.pressAvatarImage,
    this.supportImageURL,
  }) : assert(avatarImageSize != null &&
      avatarImageSize >= 0.0 &&
      avatarSquareWidth != null &&
      avatarSquareWidth >= 0.0 &&
      avatarSquareHeight != null &&
      avatarSquareHeight >= 0.0);

  @override
  Widget build(BuildContext context) {
    double _supportImageSize = this.avatarImageSize / 4;
    double avatarWidth = avatarImageSize;
    double avatarHeight = avatarImageSize;
    if (enableSquareAvatarImage) {
      if (avatarSquareWidth != 0.0) avatarWidth = avatarSquareWidth;
      if (avatarSquareHeight != 0.0) avatarHeight = avatarSquareHeight;
    }

    return Container(
      width: avatarWidth,
      height: avatarHeight,
      decoration: BoxDecoration(
        borderRadius: (this.enableSquareAvatarImage
            ? BorderRadius.all(Radius.circular(this.radiusSquareBorder))
            : BorderRadius.all(Radius.circular(this.avatarImageSize / 2))),
        border: this.avatarBoxBorder,
        boxShadow: (this.avatarBoxShadow != null
            ? [
          this.avatarBoxShadow,
        ]
            : null),
      ),
      child: GestureDetector(
        onTap: () {
          if (this.pressAvatarImage != null) {
            this.pressAvatarImage();
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ClipRRect(
              borderRadius: (this.enableSquareAvatarImage
                  ? BorderRadius.all(Radius.circular(this.radiusSquareBorder))
                  : BorderRadius.all(
                  Radius.circular(this.avatarImageSize / 2))),
              child: ImageCacheManager.getImage(
                url: this.avatarImageURL,
                height: avatarHeight,
                width: avatarWidth,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: (this.supportImageURL == null ||
                  this.supportImageURL.length == 0
                  ? null
                  : ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(_supportImageSize / 2),
                ),
                child: ImageCacheManager.getImage(
                  url: this.supportImageURL,
                  height: _supportImageSize,
                  width: _supportImageSize,
                  fit: BoxFit.cover,
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
