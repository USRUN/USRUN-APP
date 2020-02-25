import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/page/event/event_page.dart';
import 'package:usrun/page/feed/feed_page.dart';
import 'package:usrun/page/profile/profile_page.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/page/record/record_page.dart';
import 'package:usrun/page/setting/setting_page.dart';
import 'package:usrun/page/team/team_page.dart';
import 'package:usrun/widget/avatar_view.dart';

class DrawerItem {
  String title;
  String icon;
  DrawerItem(this.title, this.icon);
}

class AppPage extends StatefulWidget {
  final drawerItems = [
    DrawerItem(R.strings.record, R.myIcons.drawerRecord),
    DrawerItem(R.strings.uFeed, R.myIcons.drawerUfeed),
    DrawerItem(R.strings.events, R.myIcons.drawerEvents),
    DrawerItem(R.strings.teams, R.myIcons.drawerTeams),
    DrawerItem(R.strings.profile, R.myIcons.drawerProfile),
    DrawerItem(R.strings.settings, R.myIcons.drawerSettings),
  ];

  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
   int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new RecordPage();
      case 1:
        return new FeedPage();
      case 2:
        return new EventPage();
      case 3:
        return new TeamPage();
      case 4:
        return new ProfilePage();
      case 5:
        return new SettingPage();

      default:
        return new Text("Error");
    }
  }
  
  _onSelectItem(int index) {
    setState(() {_selectedDrawerIndex = index;});
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {

    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
        new ListTile(
          leading: new Image.asset(d.icon,width: 30, height: 30,),
          title: new Text(d.title, style: prefix0.TextStyle(fontSize: 18,color: i==_selectedDrawerIndex?Colors.yellow:Colors.white),),
          selected: i == _selectedDrawerIndex,
          onTap: () => _onSelectItem(i),
        )
      );
    }

    return Scaffold(
      appBar: GradientAppBar(gradient: R.colors.uiGradient, title: Text(widget.drawerItems[_selectedDrawerIndex].title, style: TextStyle(color: Colors.white),)),
      drawer:  Container(
          constraints: new BoxConstraints.expand(
          width: MediaQuery.of(context).size.width *0.7,
        ),
          child: Stack(children: <Widget>[ 
            Image.asset(R.images.drawer_bg, height: R.appRatio.deviceHeight + 20),
            Center(
              child: Column(
              children: <Widget>[
                SizedBox(height: R.appRatio.deviceHeight/8),
                // Container(
                //   margin: EdgeInsets.only(right: 20),
                //   width: 140,
                //   height: 140,
                //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.yellowAccent.withOpacity(0.5)),
                //   child: Align(alignment: Alignment.center, child: AvatarView(image: R.images.avatar, admin: true, size: 120,),)
                // ),
                Center(
          child: Stack(
            children: <Widget>[
                Container( width: 130,
                   height: 130,
                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.yellow[200])),
               Positioned.fill(
                 child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                  ),
                ),
               ),
              Container(
                  margin: EdgeInsets.only(right: 20),
                  width: 130,
                  height: 130,
                  child: Align(alignment: Alignment.center, child: AvatarView(image: R.images.avatar, admin: true, size: 120,),)
                ),
            ],
          ),
        ),
      
                SizedBox(height: 50,),
                Container(width: MediaQuery.of(context).size.width *0.7 - 100, child:  Column(children: drawerOptions),)
            
               ],
              ),)
            ],)
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}