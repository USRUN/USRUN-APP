import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/page/event/event_page.dart';
import 'package:usrun/page/feed/feed_page.dart';
import 'package:usrun/page/record/record_page.dart';
import 'package:usrun/page/setting/setting_page.dart';
import 'package:usrun/page/team/team_page.dart';

class SideDrawer extends StatelessWidget {
  final Function onTap;

  const SideDrawer({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: MediaQuery.of(context).size.width * 0.85, //20.0,
      child: Drawer(
          child: new ListView(
        children: <Widget>[
          new DrawerHeader(
            child: new Text("DRAWER HEADER.."),
            decoration: new BoxDecoration(color: Colors.orange),
          ),
          new ListTile(
            title: new Text(R.strings.record),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new RecordPage()));
            },
          ),
          new ListTile(
            title: new Text(R.strings.uFeed),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new FeedPage()));
            },
          ),
          new ListTile(
            title: new Text(R.strings.events),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new EventPage()));
            },
          ),
          new ListTile(
            title: new Text(R.strings.teams),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new TeamPage()));
            },
          ),
          new ListTile(
            title: new Text(R.strings.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new SettingPage()));
            },
          ),
        ],
      )),
    );
  }
}
