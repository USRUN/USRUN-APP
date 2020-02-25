import 'package:flutter/material.dart';

import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';

import 'package:usrun/util/image_cache_manager.dart';

class AvatarView extends StatelessWidget {
  final String image;
  final double size;
  final bool admin;

  AvatarView({
    @required this.image,
    this.admin = false,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: size,
      height: size,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(size / 2)),
            child: ImageCacheManager.getImage(
                url: image, width: size, height: size, fit: BoxFit.cover),
          ),
          this.admin ? Align(
            alignment: Alignment.bottomRight,
            child: Transform.rotate(
              child: Icon(
                Icons.check_circle,
                color: Colors.lightGreen,
                size: 30,
              ),
              angle: 0,
            ),
          ): Container()
        ],
      ),
    );
  }
}
