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
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_loading_dialog.dart';
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
      resizeToAvoidBottomPadding: true,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: R.appRatio.appSpacing10,
            ),
            ImageCacheManager.getImage(
              url: R.images.logoText,
              width: R.appRatio.appWelcomPageLogoTextSize,
            ),
            ImageCacheManager.getImage(
              url: R.images.pageBackground,
              width: R.appRatio.deviceWidth,
              fit: BoxFit.fitWidth,
            ),
            Expanded(
              child: Container(
                color: Color.fromRGBO(253, 99, 44, 0.075),
                padding: EdgeInsets.only(
                  left: R.appRatio.appSpacing25,
                  right: R.appRatio.appSpacing25,
                ),
                child: SlideTransition(
                  position: _offset,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      UIImageButton(
                        onTap: () {
                          _adapterSignUp(
                            LoginChannel.Facebook,
                            null,
                            context,
                          );
                        },
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
                            width: 1.5,
                          ),
                        ),
                        child: UIImageButton(
                          onTap: () {
                            _adapterSignUp(LoginChannel.Google, null, context);
                          },
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
                            color: R.colors.majorOrange,
                            width: 1.5,
                          ),
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
                                fontSize: R.appRatio.appFontSize18,
                              ),
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
                                  color: R.colors.majorOrange,
                                ),
                              ),
                              onTap: () => pushPage(context, SignInPage()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signUp(BuildContext context, LoginChannel channel,
      Map<String, String> params) async {
    showCustomLoadingDialog(context, text: R.strings.processing);
    Response<User> response = await UserManager.signIn(params);
    pop(context);

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
        //UserManager.sendDeviceToken(); //only need when using fcm
        DataManager.setLastLoginUserId(response.object.userId);
        showOnboardingPagesOrAppPage(
          context,
          popUntilFirstRoutes: false,
        );
      }
    }
//     else {
//       if (response.errorCode == USER_EMAIL_IS_USED) {
//         Map<String, dynamic> loginData = await UserManager.login(channel, params);
//         response = loginData['response'];
//         if (response.success) {
//           DataManager.setLoginChannel(channel.index);
//           showPage(context, AppPage());
//         }
//         else {
//           String message = UserManager.emailIsUserMessage(params['email']);
//           showAlert(context, R.strings.errorTitle, message, null);
//         }
//         return;
//       }

    if (response.success == false) {
      // call channel logout with
      UserManager.logout();

      showCustomAlertDialog(
        context,
        title: R.strings.errorLoginFail,
        content: response.errorMessage,
        firstButtonText: R.strings.cancel.toUpperCase(),
        firstButtonFunction: () => pop(this.context),
      );
    }
  }

  void _adapterSignUp(LoginChannel channel, Map<String, dynamic> params,
      BuildContext context) async {
    showCustomLoadingDialog(context, text: R.strings.processing);
    Map loginParams = await UserManager.adapterLogin(channel, params);
    pop(context);

    if (loginParams == null) {
      showCustomAlertDialog(
        context,
        title: R.strings.errorLoginFail,
        content: R.strings.errorLoginFail,
        firstButtonText: R.strings.cancel.toUpperCase(),
        firstButtonFunction: () => pop(this.context),
      );
    } else if (loginParams['error'] != null) {
      showCustomAlertDialog(
        context,
        title: R.strings.errorLoginFail,
        content: R.strings.errorLoginFail,
        firstButtonText: R.strings.cancel.toUpperCase(),
        firstButtonFunction: () {
          pop(this.context);
        },
      );
    } else {
      _signUp(context, channel, loginParams);
    }
  }
}
