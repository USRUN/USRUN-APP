import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/page/signin/signin_page.dart';
import 'package:usrun/page/signup/signup_page.dart';
import 'package:usrun/widget/ui_button.dart';

class WelcomePage extends StatelessWidget{
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Image.asset(R.images.welcomeBanner, width: windowWidth, fit: BoxFit.fill,),
            Center(
              child: Column(
                children: <Widget>[
                  Image.asset(R.images.logoUsRun, width: 205,),
                  SizedBox(height: windowWidth/2 + 150),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      color: Colors.white.withOpacity(0.5),
                      child: Column(
                        children: <Widget>[
                          UIImageButton(
                            image: Image.asset(R.images.loginFacebook, fit: BoxFit.contain,),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(border: Border.all(color: R.colors.majorOrange,width: 2)),
                            child: UIImageButton(
                                    image: Image.asset(R.images.loginGoogle, fit: BoxFit.contain,),
                                    ),),
                          SizedBox(height: 25,),
                          Image.asset(R.images.orLine, width: 280, color: Colors.black.withOpacity(0.4)),
                          SizedBox(height: 25,),
                          Container(
                            decoration: BoxDecoration(border: Border.all(color: R.colors.majorOrange,width: 2)),
                            child: UIImageButton(
                                    image: Image.asset(R.images.loginEmail, fit: BoxFit.contain,),
                                    onTap: () => pushPage(context, SignUpPage()),
                                    ),),
                          SizedBox(height: 25,),
                          Container(
                            width: 300,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(R.strings.alreadyAMember, style: TextStyle(fontSize: 18),),
                                SizedBox(width: 10,),
                                GestureDetector(
                                  child: Text(R.strings.signIn, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: R.colors.majorOrange),),
                                  onTap: () => pushPage(context, SignInPage()),
                                ),
                          ],),),
                          SizedBox(height: 25,)
                        ],))
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}