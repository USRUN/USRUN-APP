import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';

class FeedPage extends StatelessWidget{

   @override 
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(child: Text(R.strings.uFeed),),
    );
  }
}