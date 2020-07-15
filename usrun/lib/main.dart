import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/page/welcome/welcome_page.dart';
import 'package:usrun/page/app/app_page.dart';
import 'package:usrun/core/R.dart';
import 'package:flutter/services.dart';
import 'package:usrun/util/lifecycle_handler.dart';
import 'main.reflectable.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();
  initializeReflectable();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((res) {
    runApp(UsRunApp());
  });
}

GlobalKey<_UsRunAppState> _appGlobalkey = GlobalKey();
final navigatorKey = GlobalKey<NavigatorState>();

class UsRunApp extends StatefulWidget {
  final Widget child;

  UsRunApp({this.child}) : super(key: _appGlobalkey);

  static restartApp(int errorCode) async {
    switch (errorCode) {
      case 0:
        _restart();
        return;
      case ACCESS_DENY:
        await UserManager.logout();
        _restart();
        return;
    }
  }

  static _restart() {
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
      navigatorKey: navigatorKey,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('vi'), // Vietnamese
      ],
      title: 'USRUN',
      key: key,
      theme: ThemeData(
        primaryColor: Color(0xFFFD632C),
      ),
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
  Widget build(BuildContext context) {
    _initApp();
    return Scaffold(
      body: Center(
        child: Image.asset(
          R.images.logoText,
          width: 200,
        ),
      ),
    );
  }

  Future<void> _initApp() {
    return Future.delayed(
      Duration(milliseconds: 2000),
      () => initialize(context),
    ).then((_) {
      WidgetsBinding.instance.addObserver(NetworkObserver(context: navigatorKey.currentState.overlay.context));
      if (UserManager.currentUser.userId == null) {
        showPage(context, WelcomePage());
      } else {
        showPage(context, AppPage());
      }
    }); // Raw: WelcomePage()
  }
}
