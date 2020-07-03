import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/widget/input_field.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/util/image_cache_manager.dart';

class ChangePasswordPage extends StatelessWidget {
  final TextEditingController _currentPWController = TextEditingController();
  final TextEditingController _newPWController = TextEditingController();
  final TextEditingController _retypePWController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: R.colors.appBackground,
      appBar: GradientAppBar(
        leading: FlatButton(
          onPressed: () => pop(context),
          padding: EdgeInsets.all(0.0),
          splashColor: R.colors.lightBlurMajorOrange,
          textColor: Colors.white,
          child: ImageCacheManager.getImage(
            url: R.myIcons.appBarBackBtn,
            width: R.appRatio.appAppBarIconSize,
            height: R.appRatio.appAppBarIconSize,
          ),
        ),
        gradient: R.colors.uiGradient,
        centerTitle: true,
        title: Text(
          R.strings.changePassword,
          style: TextStyle(
              color: Colors.white, fontSize: R.appRatio.appFontSize22),
        ),
        actions: <Widget>[
          Container(
            width: R.appRatio.appWidth60,
            child: FlatButton(
              onPressed: () {
                // TODO: Function for changing password
                FocusScope.of(context).requestFocus(new FocusNode());
                // _yourFunction('yourParameter'),
              },
              padding: EdgeInsets.all(0.0),
              splashColor: R.colors.lightBlurMajorOrange,
              textColor: Colors.white,
              child: ImageCacheManager.getImage(
                url: R.myIcons.appBarCheckBtn,
                width: R.appRatio.appAppBarIconSize,
                height: R.appRatio.appAppBarIconSize,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing15,
            right: R.appRatio.appSpacing15,
          ),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: R.appRatio.appSpacing20,
                ),
                InputField(
                  controller: _currentPWController,
                  enableFullWidth: true,
                  obscureText: true,
                  labelTitle: R.strings.currentPassword,
                  hintText: R.strings.currentPassword,
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                InputField(
                  controller: _newPWController,
                  enableFullWidth: true,
                  obscureText: true,
                  labelTitle: R.strings.newPassword,
                  hintText: R.strings.newPassword,
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                InputField(
                  controller: _retypePWController,
                  enableFullWidth: true,
                  obscureText: true,
                  labelTitle: R.strings.retypePassword,
                  hintText: R.strings.retypePassword,
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                Text(
                  R.strings.passwordNotice,
                  style: TextStyle(
                      color: R.colors.orangeNoteText,
                      fontStyle: FontStyle.italic,
                      fontSize: R.appRatio.appFontSize14),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
        child: _buildElement,
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        });
  }
}
