import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/util/image_cache_manager.dart';

// ignore: must_be_immutable
class AppLogoHeading extends StatelessWidget {
  String welcome = "";

  void _updateVariableByLocale() {
    String locale = Intl.defaultLocale;
    if (locale == null || locale.length == 0) {
      locale = Intl.systemLocale.split("_")[0];
    } else {
      locale = Intl.defaultLocale.split("_")[0];
    }

    if (locale.compareTo("en") == 0) {
      welcome = "Welcome, USRUN";
    } else {
      welcome = "Chào mừng, USRUN";
    }

    initDefaultLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    _updateVariableByLocale();
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ImageCacheManager.getImage(
          url: R.images.logoText,
          width: 150,
        ),
        SizedBox(height: 15),
        Text(
          welcome,
          textScaleFactor: 1.0,
          maxLines: 1,
          style: TextStyle(
            color: Color(0xFFF26522),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
