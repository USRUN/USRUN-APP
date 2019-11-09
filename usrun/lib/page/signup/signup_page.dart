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

class SignUpPage extends StatelessWidget{

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String email;

  
  SignUpPage({this.email});

   @override 
  Widget build(BuildContext context){

    if(email != null && email.isNotEmpty) {
      _emailController.text = email;
    }

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: GradientAppBar(gradient: R.colors.uiGradient, title: Text(R.strings.signIn, style: TextStyle(color: Colors.white),),),
      //child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SizedBox(
            height: windowHeight -100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 25,),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Email", style: R.styles.labelStyle,),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: R.colors.majorOrange)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: R.colors.majorOrange)),
                        border: UnderlineInputBorder(),
                        hintText: "Type your email here",
                        hintStyle: TextStyle(fontSize: 20)
                      ),
                      ),
                      SizedBox(height: 25,),
                        Text("Password", style: R.styles.labelStyle,),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: R.colors.majorOrange)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: R.colors.majorOrange)),
                          border: UnderlineInputBorder(),
                          hintText: "Type your password here",
                          hintStyle: TextStyle(fontSize: 20)
                        ),
                      ),
                      SizedBox(height: 25,),
                        Text("Re-type Password", style: R.styles.labelStyle,),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: R.colors.majorOrange)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: R.colors.majorOrange)),
                          border: UnderlineInputBorder(),
                          hintText: "Enter your password again",
                          hintStyle: TextStyle(fontSize: 20)
                        ),
                      ),
                      SizedBox(height: 25,),
                      Text("Password must contain at least 8 characters with one number and one uppercase letter", style: TextStyle(color: R.colors.labelText,fontStyle: FontStyle.italic),)
                    ],
                  ),
                ),
                Spacer(),
                UIButton(gradient: R.colors.uiGradient, text: R.strings.signUp, onTap: () => _validateSignUpInfo(context),),
                SizedBox(height: 22,)
            ],
          ),
            ), 
            
        )
    );
  }

  void _signUp(BuildContext context, LoginChannel channel, Map<String, String> params) async {
    showLoading(context);
    Response<User> response = await UserManager.create(params);
    hideLoading(context);

    if (response.success) {
      // add user Type
      response.object.type = channel;
      if (response.object.userId == null) {
        // userId==null => prepare create user
        //showPage(context, ProfileEditPage(userInfo: response.object, loginChannel: channel, exParams: params, type: ProfileEditType.SignUp)); // pass empty user
      }
      else {
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
    if (message != null) {
      showAlert(context, R.strings.errorTitle, message, null);
      return;
    }

    Map<String, String> params = {
      'type': LoginChannel.UsRun.index.toString(),
      'email': email,
      'password': password
    };

    _adapterSignUp(LoginChannel.UsRun, params, context);
  }

  void _adapterSignUp(LoginChannel channel, Map<String, dynamic> params, BuildContext context) async {
    showLoading(context);
    Map loginParams = await UserManager.adapterLogin(channel, params);
    hideLoading(context);

    if (loginParams == null) {
      showAlert(context, R.strings.errorLoginFail, R.strings.errorLoginFail, null);
    } else if (loginParams['error'] != null) {
      showAlert(context, R.strings.errorLoginFail, loginParams['error'], null);
    } else {
      _signUp(context, channel, loginParams);
    }
  }
  
}