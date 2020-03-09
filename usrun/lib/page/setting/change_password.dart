import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/widget/input_field.dart';
import 'package:usrun/core/helper.dart';

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
        leading: new IconButton(
          icon: Image.asset(
            R.myIcons.appBarBackBtn,
            width: R.appRatio.appAppBarIconSize,
          ),
          onPressed: () => pop(context),
        ),
        gradient: R.colors.uiGradient,
        centerTitle: true,
        title: Text(
          R.strings.changePassword,
          style: TextStyle(
              color: Colors.white, fontSize: R.appRatio.appFontSize22),
        ),
        actions: <Widget>[
          IconButton(
            icon: Image.asset(
              R.myIcons.appBarCheckBtn,
              width: R.appRatio.appAppBarIconSize,
            ),
            // TODO: Function for changing password
            onPressed: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              // _yourFunction('yourParameter'),
            },
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
                  labelTitle: "Current password",
                  hintText: "Current password",
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                InputField(
                  controller: _newPWController,
                  enableFullWidth: true,
                  obscureText: true,
                  labelTitle: "New password",
                  hintText: "New password",
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                InputField(
                  controller: _retypePWController,
                  enableFullWidth: true,
                  obscureText: true,
                  labelTitle: "Re-type password",
                  hintText: "Re-type password",
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                Text(
                  "Password must contain at least 8 characters with one number and one uppercase letter",
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
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        });
  }
}
