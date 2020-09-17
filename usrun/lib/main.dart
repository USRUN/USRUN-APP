import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/page/welcome/select_language.dart';
import 'package:usrun/page/welcome/welcome_page.dart';
import 'package:usrun/page/app/app_page.dart';
import 'package:usrun/core/R.dart';
import 'package:flutter/services.dart';
import 'main.reflectable.dart';

GlobalKey<_UsRunAppState> _appGlobalKey = GlobalKey();
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final String _appName = "USRUN";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();
  initializeReflectable();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((res) {
    runApp(UsRunApp());
  });
}

class UsRunApp extends StatefulWidget {
  UsRunApp() : super(key: _appGlobalKey);

  static restartApp(int errorCode) async {
    switch (errorCode) {
      case 0:
        _restart();
        return;
      case LOGOUT_CODE:
        await UserManager.logout();
        _restart();
        return;
      case ACCESS_DENY:
        await UserManager.logout();
        _restart();
        return;
      case MAINTENANCE:
        _restart();
        return;
      case FORCE_UPDATE:
        await UserManager.logout();
        _restart();
        return;
      default:
        return;
    }
  }

  static _restart() {
    _appGlobalKey.currentState.restart();
  }

  @override
  _UsRunAppState createState() => _UsRunAppState();
}

class _UsRunAppState extends State<UsRunApp> {
  void restart() {
    setState(() {
      navigatorKey = GlobalKey<NavigatorState>();
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
      title: _appName,
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initPage());
  }

  Future<void> _initPage() async {
    await initializeConfigs(context);

    if (hasSelectedLanguageFirstTime()) {
      await loadCurrentLanguage();
    }

    openStartPage();
  }

  void openStartPage() async {
    if (hasSelectedLanguageFirstTime()) {
//      WidgetsBinding.instance.addObserver(
//          NetworkObserver(context: navigatorKey.currentState.overlay.context));

      if (UserManager.currentUser.userId == null) {
        showPage(context, WelcomePage());
      } else {
        showPage(context, AppPage());
      }
    } else {
      UserManager.logout();
      showPage(context, SelectLanguagePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: Image.asset(
          R.images.logoText,
          width: 180,
        ),
      ),
    );
  }
}
