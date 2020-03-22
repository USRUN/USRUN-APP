import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/page/signin/signin_page.dart';
import 'package:usrun/page/signup/signup_page.dart';
import 'package:usrun/widget/ui_button.dart';

class WelcomePage extends StatelessWidget {
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
                  Padding(
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
                            image: Image.asset(
                              (R.currentAppLanguage == "en"
                                  ? R.images.loginFacebookEnglish
                                  : R.images.loginFacebookVietnam),
                              fit: BoxFit.contain,
                            ),
                            width: R.appRatio.appWidth381,
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
                              image: Image.asset(
                                (R.currentAppLanguage == "en"
                                  ? R.images.loginGoogleEnglish
                                  : R.images.loginGoogleVietnam),
                                fit: BoxFit.contain,
                              ),
                              width: R.appRatio.appWidth381,
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
                              image: Image.asset(
                                (R.currentAppLanguage == "en"
                                  ? R.images.loginEmailEnglish
                                  : R.images.loginEmailVietnam),
                                fit: BoxFit.contain,
                              ),
                              width: R.appRatio.appWidth381,
                              onTap: () => pushPage(context, SignUpPage()),
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
                                  onTap: () => pushPage(context, SignInPage()),
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
