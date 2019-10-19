import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/page/welcome_page.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'main.reflectable.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();
  FlutterStatusbarManager.setColor(Colors.black.withOpacity(0));
  initializeReflectable();
  setLanguage("vi");
  runApp(UsRunApp());
}

GlobalKey<_UsRunAppState> _appGlobalkey = GlobalKey();
bool _needInit = true;


class UsRunApp extends StatefulWidget {
  
  final Widget child;
  UsRunApp({this.child}) : super(key: _appGlobalkey);

  @override
  _UsRunAppState createState() => _UsRunAppState();
}

class _UsRunAppState extends State<UsRunApp> {
  Key key = new UniqueKey();

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      key: key,
      home: SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override 
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<StatefulWidget> {

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (_needInit){
      Future.delayed(Duration(milliseconds: 100), ()=> _initApp());
    }
  }

  @override 
  Widget build(BuildContext context){
    print("Build Splash");
    return Scaffold(
      body: Center(child: Text("R.strings.usrun"),),
    );
  }

  void _initApp(){
    showPage(context, WelcomePage());
  }
}