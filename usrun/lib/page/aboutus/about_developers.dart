import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';

class AboutDevelopers extends StatelessWidget {
  Widget _renderDeveloperWidget(
    String imageURL,
    String name,
    String title, {
    bool enableLastMargin: true,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: AvatarView(
            avatarImageURL: imageURL,
            avatarImageSize: R.appRatio.appAvatarSize130,
          ),
        ),
        SizedBox(
          height: R.appRatio.appSpacing10,
        ),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: R.colors.majorOrange,
            fontSize: R.appRatio.appFontSize18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: R.appRatio.appSpacing10,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: R.colors.contentText,
            fontSize: R.appRatio.appFontSize18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: (enableLastMargin ? R.appRatio.appSpacing40 : 0),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(title: R.strings.aboutDevelopers),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing25,
            right: R.appRatio.appSpacing25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: R.appRatio.appSpacing30,
              ),
              // -----
              // DEVELOPER 1
              _renderDeveloperWidget(
                R.images.avatarNgocVTT,
                R.strings.aboutDevName_1,
                R.strings.aboutDevTitle_1,
              ),
              // DEVELOPER 2
              _renderDeveloperWidget(
                R.images.avatarPhucTT,
                R.strings.aboutDevName_2,
                R.strings.aboutDevTitle_2,
              ),
              // DEVELOPER 3
              _renderDeveloperWidget(
                R.images.avatarQuocTK,
                R.strings.aboutDevName_3,
                R.strings.aboutDevTitle_3,
              ),
              // DEVELOPER 4
              _renderDeveloperWidget(
                R.images.avatarKhaTM,
                R.strings.aboutDevName_4,
                R.strings.aboutDevTitle_4,
              ),
              // DEVELOPER 5
              _renderDeveloperWidget(
                R.images.avatarHuyTA,
                R.strings.aboutDevName_5,
                R.strings.aboutDevTitle_5,
                enableLastMargin: false,
              ),
              // -----
              SizedBox(
                height: R.appRatio.appSpacing30,
              ),
            ],
          ),
        ),
      ),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
      child: _buildElement,
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return false;
      },
    );
  }
}
