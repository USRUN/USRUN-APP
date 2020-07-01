import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/data_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/page/app/app_page.dart';
import 'package:usrun/page/signin/signin_page.dart';
import 'package:usrun/page/signup/signup_page.dart';
import 'package:usrun/widget/ui_button.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..forward();
    _offset =
        Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Image.asset(
              R.images.welcomeBanner,
              width: R.appRatio.deviceWidth,
              height: R.appRatio.deviceHeight,
              fit: BoxFit.cover,
            ),
            Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: R.appRatio.appSpacing10,
                  ),
                  Image.asset(
                    R.images.logoText,
                    width: R.appRatio.appWelcomPageLogoTextSize,
                  ),
                  Spacer(),
                  SlideTransition(
                    position: _offset,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: R.appRatio.appSpacing25,
                        right: R.appRatio.appSpacing25,
                        bottom: R.appRatio.appSpacing25,
                      ),
                      child: Container(
                        color: Colors.white.withOpacity(0.5),
                        child: Column(
                          children: <Widget>[
                            UIImageButton(
                              onTap: (){_adapterSignUp(LoginChannel.Facebook, null, context);},
                              width: R.appRatio.appWidth381,
                              image: Image.asset(
                                (R.currentAppLanguage == "en"
                                    ? R.images.loginFacebookEnglish
                                    : R.images.loginFacebookVietnam),
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(
                              height: R.appRatio.appSpacing15,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: R.colors.majorOrange,
                                  width: 2,
                                ),
                              ),
                              child: UIImageButton(
                                onTap: (){_adapterSignUp(LoginChannel.Google, null, context);},
                                width: R.appRatio.appWidth381,
                                image: Image.asset(
                                  (R.currentAppLanguage == "en"
                                      ? R.images.loginGoogleEnglish
                                      : R.images.loginGoogleVietnam),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: R.appRatio.appSpacing15,
                            ),
                            Image.asset(
                              R.images.orLine,
                              width: R.appRatio.appWidth300,
                              color: Colors.black.withOpacity(0.4),
                            ),
                            SizedBox(
                              height: R.appRatio.appSpacing15,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: R.colors.majorOrange, width: 2),
                              ),
                              child: UIImageButton(
                                width: R.appRatio.appWidth381,
                                onTap: () => pushPage(context, SignUpPage()),
                                image: Image.asset(
                                  (R.currentAppLanguage == "en"
                                      ? R.images.loginEmailEnglish
                                      : R.images.loginEmailVietnam),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: R.appRatio.appSpacing15,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    R.strings.alreadyAMember,
                                    style: TextStyle(
                                        fontSize: R.appRatio.appFontSize18),
                                  ),
                                  SizedBox(
                                    width: R.appRatio.appSpacing15,
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      R.strings.signIn,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: R.appRatio.appFontSize18,
                                          color: R.colors.majorOrange),
                                    ),
                                    onTap: () =>
                                        pushPage(context, SignInPage()),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: R.appRatio.appSpacing15,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _signUp(BuildContext context, LoginChannel channel,
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


  void _adapterSignUp(LoginChannel channel, Map<String, dynamic> params,
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
      _signUp(context, channel, loginParams);
    }
  }
}
