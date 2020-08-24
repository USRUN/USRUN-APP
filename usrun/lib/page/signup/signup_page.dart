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
import 'package:usrun/page/setting/hcmus_email_verification.dart';
import 'package:usrun/util/validator.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_loading_dialog.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/ui_button.dart';
import 'package:usrun/widget/input_field.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();
  final String email;

  SignUpPage({this.email});

  @override
  Widget build(BuildContext context) {
    if (email != null && email.isNotEmpty) {
      _emailController.text = email;
    }

    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(title: R.strings.signUp),
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
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: R.appRatio.appWidth181,
                              child: InputField(
                                controller: _firstNameController,
                                enableFullWidth: false,
                                labelTitle: R.strings.firstName,
                                hintText: R.strings.firstName,
                                autoFocus: true,
                              ),
                            ),
                            Container(
                              width: R.appRatio.appWidth181,
                              child: InputField(
                                controller: _lastNameController,
                                enableFullWidth: false,
                                labelTitle: R.strings.lastName,
                                hintText: R.strings.lastName,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: R.appRatio.appSpacing25,
                        ),
                        InputField(
                          controller: _emailController,
                          enableFullWidth: true,
                          labelTitle: R.strings.email,
                          hintText: R.strings.email,
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
                          height: R.appRatio.appSpacing25,
                        ),
                        InputField(
                          controller: _retypePasswordController,
                          enableFullWidth: true,
                          labelTitle: R.strings.retypePassword,
                          hintText: R.strings.retypePasswordHint,
                          obscureText: true,
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
                        )
                      ],
                    ),
                  ),
                ],
              ),
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
                height: R.appRatio.appHeight50,
                gradient: R.colors.uiGradient,
                text: R.strings.signUp,
                textSize: R.appRatio.appFontSize18,
                onTap: () => _validateSignUpInfo(context),
              ),
            ),
          ),
        ),
      ]),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
        child: _buildElement,
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        });
  }

  void _signUp(BuildContext context, LoginChannel channel,
      Map<String, String> params) async {
    showCustomLoadingDialog(context, text: R.strings.processing);
    Response<User> response = await UserManager.create(params);
    pop(context);

    if (response.success) {
      // add user Type
      response.object.type = channel;
      if (response.object.userId == null) {
        // userId==null => prepare create user
        //showPage(context, ProfileEditPage(userInfo: response.object, loginChannel: channel, exParams: params, type: ProfileEditType.SignUp)); // pass empty user
      } else {
        if (channel == LoginChannel.UsRun &&
            response.object.email.contains("hcmus.edu.vn")) {
          await showCustomAlertDialog(
            context,
            title: R.strings.notice,
            content: R.strings.verificationNotice,
            firstButtonText: R.strings.settingsVerifyButton.toUpperCase(),
            firstButtonFunction: () async {
              bool result = await pushPage(context, HcmusEmailVerification());

              if (result) {
                response.object.hcmus = true;
              }

              pop(context);
            },
            secondButtonText: R.strings.cancel,
            secondButtonFunction: () {
              pop(context);
            },
          );
        }

        // có user và đúng thông tin => save user + goto app page
        UserManager.saveUser(response.object);
        DataManager.setLoginChannel(channel.index);
        //UserManager.sendDeviceToken();
        DataManager.setLastLoginUserId(response.object.userId);

        Future.delayed(Duration(milliseconds: 350), () {
          showPage(
            context,
            AppPage(),
            popUntilFirstRoutes: true,
          );
        });
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

  void _validateSignUpInfo(BuildContext context) {
    String message;

    // validate email
    String email = _emailController.text.trim();
    String displayName = _firstNameController.text.trim() +
        " " +
        _lastNameController.text.trim();
    bool validate = validateEmail(email);
    if (!validate) {
      message = R.strings.errorInvalidEmail;
    }

    if (message != null) {
      showCustomAlertDialog(
        context,
        title: R.strings.error,
        content: message,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(context),
      );
      return;
    }

    // validate password
    String password = _passwordController.text.trim();
    message = validatePassword(password);
    if (message != null) {
      showCustomAlertDialog(
        context,
        title: R.strings.error,
        content: message,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(context),
      );
      return;
    }

    Map<String, String> params = {
      'type': LoginChannel.UsRun.index.toString(),
      'displayName': displayName,
      'email': email,
      'password': password
    };

    _adapterSignUp(LoginChannel.UsRun, params, context);
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
      _signUp(context, channel, loginParams);
    }
  }
}
