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
                      labelTitle: "Email",
                      hintText: "Type your email here",
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: R.appRatio.appSpacing25,
                    ),
                    InputField(
                      controller: _passwordController,
                      enableFullWidth: true,
                      labelTitle: "Password",
                      hintText: "Type your password here",
                      obscureText: true,
                    ),
                    SizedBox(
                      height: R.appRatio.appSpacing40,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () => pushPage(context, ResetPasswordPage()),
                        child: Text(
                          "Forget Password",
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
      ]),
    );
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
    }
    // else {
    //   if (response.errorCode == USER_EMAIL_IS_USED) {
    //     Map<String, dynamic> loginData = await UserManager.login(channel, params);
    //     response = loginData['response'];
    //     if (response.success) {
    //       DataManager.setLoginChannel(channel.index);
    //       showPage(context, AppPage());
    //     }
    //     else {
    //       String message = UserManager.emailIsUserMessage(params['email']);
    //       showAlert(context, R.strings.errorTitle, message, null);
    //     }
    //     return;
    //   }

    //   if (response.success == false) {
    //     // call channel logout with
    //     showLoading(context);
    //     UserManager.logout();
    //     hideLoading(context);

    //     showAlert(context, R.strings.errorTitle, response.errorMessage, null);
    //   }
    // }
  }

  void _adapterSignIn(LoginChannel channel, Map<String, dynamic> params,
    BuildContext context) async {
    showLoading(context);
    Map loginParams = await UserManager.adapterLogin(channel, params);
    hideLoading(context);

    if (loginParams == null) {
      showAlert(
          context, R.strings.errorLoginFail, R.strings.errorLoginFail, null);
    } else if (loginParams['error'] != null) {
      showAlert(context, R.strings.errorLoginFail, loginParams['error'], null);
    } else {
      _signIn(context, channel, loginParams);
    }
  }

  _getSignInInfo(BuildContext context){
String message;

    // validate email
    String email = _emailController.text.trim();
    message = validateEmail(email);
    if (message != null) {
      showAlert(context, R.strings.errorTitle, message, null);
      return;
    }

    // validate password
    String password = _passwordController.text.trim();

     if (message != null) {
      showAlert(context, R.strings.errorTitle, message, null);
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
