import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/page/welcome/welcome_page.dart';
import 'package:usrun/core/R.dart';
import 'main.reflectable.dart';
import 'package:flutter/services.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();
  initializeReflectable();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((res) {
    runApp(UsRunApp());
  });
}

GlobalKey<_UsRunAppState> _appGlobalkey = GlobalKey();
bool _needInit = true;

class UsRunApp extends StatefulWidget {
  final Widget child;
  UsRunApp({this.child}) : super(key: _appGlobalkey);

  static restartApp(int errorCode) async {
    if (errorCode == 0) {
      _restart();
    } else {
      if (errorCode == ACCESS_DENY) {
        //await UserManager.logout();
        //_resetUserConnectCheck();
        _restart();
        return;
      }

      //update deviceToken to ""
      Map<String, String> newData = {
        'deviceToken': "",
        'os': getPlatform().toString()
      };
      //Response response = await UserManager.updateProfile(newData);

      // if (response.success) {
      //   await UserManager.logout();
      //   _resetUserConnectCheck();
      //   _restart();
      // } else {
      //   showAlert(_appGlobalKey.currentState.context, R.strings.errorTitle, R.strings.errorLogoutFail, null);
      // }
    }
  }

  static _restart() {
    _needInit = true;
    _appGlobalkey.currentState.restart();
  }

  @override
  _UsRunAppState createState() => _UsRunAppState();
}

class _UsRunAppState extends State<UsRunApp> {
  Key key = new UniqueKey();

  void restart() {
    setState(() {
      key = new UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

    if (_needInit) {
      Future.delayed(Duration(milliseconds: 100), () => _initApp());
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Build Splash");
    return Scaffold(
      body: Center(
        child: Image.asset(
          R.images.logoText,
          width: 200,
        ),
      ),
    );
  }

  void _initApp() async {
    await initialize(context);
    showPage(context, WelcomePage());
  }
}
