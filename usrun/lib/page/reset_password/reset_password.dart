import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/widget/ui_button.dart';
import 'package:usrun/widget/input_field.dart';

class ResetPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          R.strings.resetPassword,
          style: TextStyle(
              color: Colors.white, fontSize: R.appRatio.appFontSize22),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(
          left: R.appRatio.appSpacing15,
          right: R.appRatio.appSpacing15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: R.appRatio.appSpacing20,
            ),
            Text(
              R.strings.resetPasswordNotice,
              style: TextStyle(
                color: R.colors.majorOrange,
                fontSize: R.appRatio.appFontSize18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: R.appRatio.appSpacing30,
            ),
            InputField(
              controller: _emailController,
              enableFullWidth: true,
              hintText: R.strings.email,
            ),
            SizedBox(
              height: R.appRatio.appSpacing40,
            ),
            UIButton(
                width: R.appRatio.appWidth381,
                height: R.appRatio.appHeight60,
                gradient: R.colors.uiGradient,
                text: R.strings.reset,
                textSize: R.appRatio.appFontSize22,
                // TODO: Function for resetting password
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  //_yourFunction('yourParameter'),
                }),
          ],
        ),
      ),
    );
  }
}
