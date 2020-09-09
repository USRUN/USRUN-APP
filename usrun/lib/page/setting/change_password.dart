import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/util/validator.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/input_field.dart';

class ChangePasswordPage extends StatelessWidget {
  final TextEditingController _currentPWController = TextEditingController();
  final TextEditingController _newPWController = TextEditingController();
  final TextEditingController _retypePWController = TextEditingController();

  final FocusNode _currentPWNode = FocusNode();
  final FocusNode _newPWNode = FocusNode();
  final FocusNode _retypePWNode = FocusNode();

  void _changePassword(BuildContext context) async {
    String newPassword = _newPWController.text.trim();
    String oldPassword = _currentPWController.text.trim();
    String retypeNewPassword = _retypePWController.text.trim();
    String alertMsg;

    if (alertMsg == null) {
      if (newPassword.isEmpty ||
          oldPassword.isEmpty ||
          retypeNewPassword.isEmpty) {
        alertMsg = R.strings.settingsCPEmptyField;
      }
    }

    if (alertMsg == null &&
        (validatePassword(oldPassword) != null ||
            validatePassword(newPassword) != null ||
            validatePassword(retypeNewPassword) != null)) {
      alertMsg = R.strings.settingsCPInvalidPwd;
    }

    if (alertMsg == null && newPassword != retypeNewPassword) {
      alertMsg = R.strings.settingsCPPwdNotMatch;
    }

    if (alertMsg == null && newPassword == oldPassword) {
      alertMsg = R.strings.settingsCPNewPwdDifferent;
    }

    if (alertMsg != null) {
      showCustomAlertDialog(
        context,
        title: R.strings.error,
        content: alertMsg,
        firstButtonText: R.strings.cancel.toUpperCase(),
        firstButtonFunction: () => pop(context),
      );
      return;
    }

    Response<dynamic> changePasswordRequest =
        await UserManager.changePassword(oldPassword, newPassword);

    if (changePasswordRequest.success) {
      showCustomAlertDialog(
        context,
        title: R.strings.error,
        content: R.strings.settingsChangePasswordSuccessful,
        firstButtonText: R.strings.settingsCPReLogin.toUpperCase(),
        firstButtonFunction: () => pop(context),
      );
    } else {
      showCustomAlertDialog(
        context,
        title: R.strings.error,
        content: changePasswordRequest.errorMessage,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(
        title: R.strings.changePassword,
        actions: <Widget>[
          Container(
            width: R.appRatio.appWidth60,
            child: FlatButton(
              onPressed: () {
                _changePassword(context);
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
                  focusNode: _currentPWNode,
                  controller: _currentPWController,
                  enableFullWidth: true,
                  obscureText: true,
                  labelTitle: R.strings.currentPassword,
                  hintText: R.strings.currentPassword,
                  autoFocus: true,
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                InputField(
                  focusNode: _newPWNode,
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
                  focusNode: _retypePWNode,
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
                    fontSize: R.appRatio.appFontSize16,
                  ),
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
