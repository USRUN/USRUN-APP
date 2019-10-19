import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';

class WelcomePage extends StatelessWidget{
  @override 
  Widget build(BuildContext context){
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Center(child: Text(R.strings.usrun),),
      ),
    );
  }
}