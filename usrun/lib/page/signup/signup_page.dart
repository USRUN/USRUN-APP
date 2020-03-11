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
          R.strings.signUp,
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
                                labelTitle: "First Name",
                                hintText: "First Name",
                              ),
                            ),
                            Container(
                              width: R.appRatio.appWidth181,
                              child: InputField(
                                controller: _lastNameController,
                                enableFullWidth: false,
                                labelTitle: "Last Name",
                                hintText: "Last Name",
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
                          height: R.appRatio.appSpacing25,
                        ),
                        InputField(
                          controller: _retypePasswordController,
                          enableFullWidth: true,
                          labelTitle: "Re-type Password",
                          hintText: "Enter your password again",
                          obscureText: true,
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
                height: R.appRatio.appHeight60,
                gradient: R.colors.uiGradient,
                text: R.strings.signUp,
                textSize: R.appRatio.appFontSize22,
                onTap: () => _validateSignUpInfo(context),
              ),
            ),
          ),
        ),
      ]),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
        child: _buildElement,
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        });
  }

  void _signUp(BuildContext context, LoginChannel channel,
      Map<String, String> params) async {
    showLoading(context);
    Response<User> response = await UserManager.create(params);
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

  void _validateSignUpInfo(BuildContext context) {
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
    message = validatePassword(password);
    String retypePassword = _retypePasswordController.text.trim();
    if (password!=retypePassword)
    {
      message = "Incorrect Password";
    }

    if (message != null) {
      showAlert(context, R.strings.errorTitle, message, null);
      return;
    }

    String name = _firstNameController.text + " " + _lastNameController.text;

    Map<String, String> params = {
      'type': LoginChannel.UsRun.index.toString(),
      'name': name,
      'email': email,
      'password': password
    };

    _adapterSignUp(LoginChannel.UsRun, params, context);
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
