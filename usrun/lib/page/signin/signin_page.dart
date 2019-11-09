import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/page/app/app_page.dart';
import 'package:usrun/widget/ui_button.dart';

class SignInPage extends StatelessWidget{

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

   @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: GradientAppBar(gradient: R.colors.uiGradient, title: Text(R.strings.signIn, style: TextStyle(color: Colors.white),),),
      body:  Container(
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
                      Center(child: GestureDetector(child: Text("Forget Password", style: R.styles.labelStyle,),),)
                    ],
                  ),
                ),
                Spacer(),
                UIButton(gradient: R.colors.uiGradient, text: R.strings.signIn, onTap: () => showPage(context, AppPage()),),
                SizedBox(height: 22,)
            ],
          ),
            ), 
            
        )
    );
  }
}