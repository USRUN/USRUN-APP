import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';

class ProfilePage extends StatelessWidget{

   @override 
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: R.colors.appBackground,
      body: Center(child: Text(R.strings.profile),),
    );
  }
}