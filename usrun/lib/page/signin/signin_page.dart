import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/data_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/page/app/app_page.dart';
import 'package:usrun/page/reset_password/reset_password.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/ui_button.dart';
import 'package:usrun/widget/input_field.dart';
import 'package:usrun/util/image_cache_manager.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: false,
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
          R.strings.signIn,
          style: TextStyle(
              color: Colors.white, fontSize: R.appRatio.appFontSize22),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
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
                  onTap: () => _getSignInInfo(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
        child: _buildElement,
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        });
  }

  _signIn(BuildContext context, LoginChannel channel,
      Map<String, String> params) async {
    showLoading(context);
    Response<User> response = await UserManager.signIn(params);
    hideLoading(context);

    if (response.success) {
      // add user Type
      response.object.type = channel;
      if (response.object.userId == null) {
        // userId==null => prepare create user
        //showPage(context, ProfileEditPage(userInfo: response.object, loginChannel: channel, exParams: params, type: ProfileEditType.SignUp)); // pass empty user
      } else {
        // có user và đúng thông tin => save user + goto app page
        UserManager.saveUser(response.object);
        DataManager.setLoginChannel(channel.index);
        UserManager.sendDeviceToken();
        DataManager.setLastLoginUserId(response.object.userId);
        showPage(context, AppPage());
      }
    } else {
      // call channel logout with
      showLoading(context);
      UserManager.logout();
      hideLoading(context);

      showCustomAlertDialog(
        context,
        title: R.strings.errorTitle,
        content: response.errorMessage,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(context),
      );
    }
  }

  void _adapterSignIn(LoginChannel channel, Map<String, dynamic> params,
      BuildContext context) async {
    showLoading(context);
    Map loginParams = await UserManager.adapterLogin(channel, params);
    hideLoading(context);

    if (loginParams == null) {
      showCustomAlertDialog(
        context,
        title: R.strings.errorLoginFail,
        content: R.strings.errorLoginFail,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(context),
      );
    } else if (loginParams['error'] != null) {
      showCustomAlertDialog(
        context,
        title: R.strings.errorLoginFail,
        content: loginParams['error'],
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(context),
      );
    } else {
      _signIn(context, channel, loginParams);
    }
  }

  _getSignInInfo(BuildContext context) {
    String message;

    // validate email
    String email = _emailController.text.trim();
    message = validateEmail(email);
    if (message != null) {
      showCustomAlertDialog(
        context,
        title: R.strings.errorTitle,
        content: message,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(context),
      );
      return;
    }

    // validate password
    String password = _passwordController.text.trim();

    if (message != null) {
      showCustomAlertDialog(
        context,
        title: R.strings.errorTitle,
        content: message,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(context),
      );
      return;
    }

    Map<String, String> params = {
      'type': LoginChannel.UsRun.index.toString(),
      'email': email,
      'password': password
    };

    _adapterSignIn(LoginChannel.UsRun, params, context);
  }
}
