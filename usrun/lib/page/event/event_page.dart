import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/event_manager.dart';

class EventPage extends StatelessWidget{

   @override 
  Widget build(BuildContext context){
     _getUserEvent();
    return Scaffold(
      body: Center(child: Text(R.strings.events),),
    );
  }

  _getUserEvent() async {
     await EventManager.getUserEvents();
  }
}