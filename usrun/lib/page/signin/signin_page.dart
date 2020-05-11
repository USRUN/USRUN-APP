import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/page/app/app_page.dart';
import 'package:usrun/page/reset_password/reset_password.dart';
import 'package:usrun/widget/ui_button.dart';
import 'package:usrun/widget/input_field.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
          R.strings.signIn,
          style: TextStyle(
              color: Colors.white, fontSize: R.appRatio.appFontSize22),
        ),
      ),
      body: CustomScrollView(slivers: <Widget>[
        SliverToBoxAdapter(
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
                      controller: _emailController,
                      enableFullWidth: true,
                      labelTitle: R.strings.email,
                      hintText: R.strings.emailHint,
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: R.appRatio.appSpacing25,
                    ),
                    InputField(
                      controller: _passwordController,
                      enableFullWidth: true,
                      labelTitle: R.strings.password,
                      hintText: R.strings.passwordHint,
                      obscureText: true,
                    ),
                    SizedBox(
                      height: R.appRatio.appSpacing40,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () => pushPage(context, ResetPasswordPage()),
                        child: Text(
                          R.strings.forgotPassword,
                          style: R.styles.shadowLabelStyle,
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          fillOverscroll: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: R.appRatio.appSpacing25,
                bottom: R.appRatio.appSpacing25,
              ),
              child: UIButton(
                width: R.appRatio.appWidth381,
                height: R.appRatio.appHeight60,
                gradient: R.colors.uiGradient,
                text: R.strings.signIn,
                textSize: R.appRatio.appFontSize22,
                onTap: () => showPage(context, AppPage()),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
