import 'package:flutter/material.dart';

import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';

import 'package:usrun/util/image_cache_manager.dart';

class AvatarView extends StatelessWidget {
  // final String teamImageURL;
  // final bool isVerfiedTeam;

  final String avatarImageURL;
  final double avatarImageSize;
  final BoxShadow avatarBoxShadow;
  final BoxBorder avatarBoxBorder;
  final bool enableSquareAvatarImage;
  final double radiusSquareBorder;
  final Function pressAvatarImage;
  final String supportImageURL;

  AvatarView({
    @required this.avatarImageURL,
    @required this.avatarImageSize,
    this.avatarBoxShadow,
    this.avatarBoxBorder,
    this.enableSquareAvatarImage = false,
    this.radiusSquareBorder = 5,
    this.pressAvatarImage,
    this.supportImageURL,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: this.avatarImageSize,
        height: this.avatarImageSize,
        decoration: BoxDecoration(
          color: Colors.white,
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
                borderRadius: BorderRadius.all(
                  Radius.circular(this.avatarImageSize / 2),
                ),
                child: ImageCacheManager.getImage(
                  url: this.avatarImageURL,
                  width: this.avatarImageSize,
                  height: this.avatarImageSize,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: (this.supportImageURL == null
                    ? null
                    : ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular((this.avatarImageSize / 4) / 2),
                        ),
                        child: ImageCacheManager.getImage(
                          url: this.supportImageURL,
                          fit: BoxFit.cover,
                          width: this.avatarImageSize / 4,
                          height: this.avatarImageSize / 4,
                        ),
                      )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
