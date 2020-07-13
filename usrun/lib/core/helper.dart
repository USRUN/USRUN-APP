import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/main.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/ui_button.dart';

import '../manager/data_manager.dart';
import 'R.dart';

// === MAIN === //
Future<void> initialize(BuildContext context) async {
  await setLanguage("en");
  R.initAppRatio(context);
  await DataManager.initialize();
  UserManager.initialize();
}


// === ALERT === //
Future<T> showAlert<T>(
    BuildContext context, String title, String message, List<Widget> actions) {
  if (actions == null) {
    actions = [
      CupertinoButton(
        child: Text(R.strings.ok),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )
    ];
  }
  return showCupertinoDialog<T>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: actions,
        );
      });
}


enum RouteType {
  push,
  present,
  show,
}

Future setLanguage(String lang) async {
  String jsonContent =
      await rootBundle.loadString("assets/localization/$lang.json");
  R.initLocalized(lang, jsonContent);
}

Future<T> showActionSheet<T>(BuildContext context, Widget builderItem,
    double height, List<Widget> actions,
    [EdgeInsets padding = const EdgeInsets.all(20)]) {
  Widget buttonContent;
  if (actions.length == 2) {
    Widget left = actions[0];
    Widget right = actions[1];

    buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        left,
        SizedBox(width: 20),
        right,
      ],
    );
  } else {
    buttonContent = Column(
      children: actions,
    );
  }

  return showCupertinoModalPopup<T>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        child: Container(
          padding: padding,
          height: height,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14), topRight: Radius.circular(14))),
          child: Column(
            children: <Widget>[
              builderItem,
              SizedBox(height: 30),
              buttonContent,
            ],
          ),
        ),
      );
    },
  );
}

int _errorCode = 0;

void setErrorCode(int code) {
  _errorCode = code;
}

void restartApp(int errorCode) {
  _errorCode = errorCode;
  UsRunApp.restartApp(errorCode);
}

void showSystemMessage(BuildContext context) {
  if (_errorCode != 0) {
    Future.delayed(Duration(seconds: 0), () {
      String message;
      switch (_errorCode) {
        case LOGOUT_CODE:
          _errorCode = 0;
          return;
        case ACCESS_DENY:
          _errorCode = 0;
          message = R.strings.error + "$ACCESS_DENY";
          break;
        default:
          _errorCode = 0;
          message = "";
          return;
      }

      showCustomAlertDialog(
        context,
        title: R.strings.notice,
        content: message,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(context),
      );
    });
  }
}

// === NAVIGATOR === //

void showPage<T>(
  BuildContext context,
  Widget page, {
  bool popAllRoutes = false,
}) {
  hideLoading(context);

  if (popAllRoutes) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Route route = MaterialPageRoute(builder: (context) => page);
  Navigator.of(context).pushReplacement(route);
}

Future<T> pushPageWithRoute<T>(BuildContext context, Route<T> route) {
  if (_errorCode == MAINTENANCE) {
    showSystemMessage(context);
    return null;
  }

  hideLoading(context);
  return Navigator.of(context).push(route);
}

Future<T> pushPage<T>(BuildContext context, Widget page) {
  if (_errorCode == MAINTENANCE) {
    showSystemMessage(context);
    return null;
  }

  hideLoading(context);

  Route<T> route = _FullPageRoute<T>(
      animationType: RouteType.push, builder: (context) => page);
  return Navigator.of(context).push(route);
}

Future<T> presentPage<T>(BuildContext context, Widget page) {
  if (_errorCode == MAINTENANCE) {
    showSystemMessage(context);
    return null;
  }

  hideLoading(context);

  Route<T> route = _FullPageRoute<T>(
      animationType: RouteType.present, builder: (context) => page);
  return Navigator.of(context).push(route);
}

Future<T> replacePage<T>(BuildContext context, Widget page, {dynamic result}) {
  if (_errorCode == MAINTENANCE) {
    showSystemMessage(context);
    return null;
  }

  hideLoading(context);

  CupertinoPageRoute<T> route =
      CupertinoPageRoute<T>(fullscreenDialog: true, builder: (context) => page);
  return Navigator.of(context).pushReplacement(route, result: result);
}

void pop(BuildContext context, {bool rootNavigator = false, dynamic object}) {
  if (rootNavigator == null) rootNavigator = false;
  Navigator.of(context, rootNavigator: rootNavigator).pop(object);
}

// === VALIDATE === //
int getPlatform() {
  return Platform.isIOS ? PlatformType.iOS.index : PlatformType.Android.index;
}

String validateEmail(String email) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  return regExp.hasMatch(email) ? null : R.strings.errorEmailInvalid;
}

String validatePassword(String pass) {
  int length = pass.length;
  if (length < 8) {
    return R.strings.errorPasswordShort;
  }

  if (pass.trim().isEmpty) {
    return R.strings.errorInvalidPassword;
  }

  // TODO: add more validate password logic

  return null;
}

// === LOADING === //
_IndicatorRoute _indicator;

void showLoading(BuildContext context) {
  if (_indicator == null) {
    _indicator = _IndicatorRoute();

//    Future.delayed(Duration.zero, () => Navigator.of(context, rootNavigator: true).push(_indicator));
    Navigator.of(context, rootNavigator: true).push(_indicator);
  }
}

void hideLoading(BuildContext context) {
  if (_indicator != null) {
    Navigator.of(context, rootNavigator: true).pop(_indicator);
    _indicator = null;
  }
}

Future<File> handleImagePicked(BuildContext context, CropStyle cropStyle, File photo, int maxWidth, int maxHeight, int quality) async {
    int initSize = (await photo.length() ~/ 1000);

    if(initSize > 5500){
    // Image too large, abort
      await showCustomAlertDialog(context, title: "Image upload failed", content: "The image is too large. Please choose another image to upload.", firstButtonText: R.strings.ok, firstButtonFunction: ()=>{pop(context,object: null)}, secondButtonText: "");
      return null;
    }
    if(initSize > 3800){
      quality = (4000 * 77) ~/ initSize;
    }

    File result = await ImageCropper.cropImage(sourcePath: photo.path,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      cropStyle: cropStyle,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: quality,
      androidUiSettings: R.imagePickerDefaults.defaultAndroidSettings
    );

    return result;
  }

Future<File> pickImageByShape(BuildContext context, CropStyle shape, {int maxWidth = 800, int maxHeight = 600, int quality = 80}) async {
  Widget w = Material(
    type: MaterialType.transparency,
    child: Column(
      children: <Widget>[
        Text(R.strings.chooseImage, style: R.styles.labelStyle),
        Divider(color: R.colors.majorOrange, height: 24),
        UIButton(
          text: R.strings.gallery,
          gradient: R.colors.uiGradient,
          onTap: () async {
            File photo = await ImagePicker.pickImage(
                source: ImageSource.gallery);
            if (photo == null) {
              pop(context, object: null);
            } else {
              pop(context, object: await handleImagePicked(context, shape, photo, maxWidth, maxHeight, quality));
            }
          },
        ),
        SizedBox(height: 10),
        UIButton(
          text: R.strings.camera,
          gradient: R.colors.uiGradient,
          onTap: () async {
            File photo = await ImagePicker.pickImage(
              source: ImageSource.camera,
            );
            if (photo == null) {
              pop(context, object: null);
            } else {
              pop(context, object: await handleImagePicked(context, shape, photo, maxWidth, maxHeight, quality));
            }
          },
        ),
        SizedBox(height: 30),
        UIButton(
          text: R.strings.cancel,
          gradient: R.colors.uiGradient,
          onTap: () => pop(context, object: null),
        ),
      ],
    ),
  );


  File photo = await showActionSheet<File>(context, w, 350, []);

  return photo;
  }

Future<File> pickImage(BuildContext context, {double maxWidth = 800, double maxHeight = 600, int quality = 80}) async {

  Widget w = Material(
    type: MaterialType.transparency,
    child: Column(
      children: <Widget>[
        Text(R.strings.chooseImage, style: R.styles.labelStyle),
        Divider(color: R.colors.majorOrange, height: 24),
        UIButton(
          text: R.strings.gallery,
          gradient: R.colors.uiGradient,
          onTap: () async {
            File photo = await ImagePicker.pickImage(
                source: ImageSource.gallery,
                maxWidth: maxWidth,
                maxHeight: maxHeight,
                imageQuality: quality);
            if (photo == null) {
              pop(context, object: null);
            } else {
//              File result = await ImageCropper.cropImage(sourcePath: photo.path,maxHeight: maxHeight.toInt(),maxWidth: maxWidth.toInt());
              pop(context, object: photo);
            }
          },
        ),
        SizedBox(height: 10),
        UIButton(
          text: R.strings.camera,
          gradient: R.colors.uiGradient,
          onTap: () async {
            File photo = await ImagePicker.pickImage(
                source: ImageSource.camera,
                maxWidth: maxWidth,
                maxHeight: maxHeight,
                imageQuality: quality
            );
            if (photo == null) {
              pop(context, object: null);
            } else {
              //File result = await _cropImage(photo);
              pop(context, object: photo);
            }
          },
        ),
        SizedBox(height: 30),
        UIButton(
          text: R.strings.cancel,
          gradient: R.colors.uiGradient,
          onTap: () => pop(context, object: null),
        ),
      ],
    ),
  );

  File photo = await showActionSheet<File>(context, w, 350, []);

  return photo;
}

// Future<File> _cropImage(File imageFile) async {
//   File croppedFile = await ImageCropper.cropImage(
//     sourcePath: imageFile.path,
//   );
//   return croppedFile;
// }

class _IndicatorRoute<T> extends ModalRoute {
  _IndicatorRoute(
      {bool barrierDismissible = true,
      String barrierLabel,
      Color barrierColor = const Color(0x80000000),
      RouteSettings settings})
      : assert(barrierDismissible != null),
        _barrierDismissible = barrierDismissible,
        _barrierLabel = barrierLabel,
        _barrierColor = barrierColor,
        super(settings: settings) {
    Future.delayed(loadingTimeout, () {
      isClosable = true;
    });
  }

  final Duration loadingTimeout = Duration(seconds: 30);
  bool isClosable = false;

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  String get barrierLabel => _barrierLabel;
  final String _barrierLabel;

  @override
  Color get barrierColor => _barrierColor;
  final Color _barrierColor;

  @override
  bool get opaque => false;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration.zero;

  @override
  Future<RoutePopDisposition> willPop() {
    if (!isClosable) return Future.value(RoutePopDisposition.doNotPop);
    return super.willPop();
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return GestureDetector(
      onTap: () {
        if (isClosable) hideLoading(context);
      },
      child: Semantics(
        child: CupertinoActivityIndicator(
          radius: 20,
          animating: true,
        ),
        scopesRoute: true,
        explicitChildNodes: true,
      ),
    );
  }
}

class _NoAnimateRoute<T> extends CupertinoPageRoute<T> {
  _NoAnimateRoute({
    WidgetBuilder builder,
    RouteSettings settings,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

class _FullPageRoute<T> extends PageRoute<T> {
  _FullPageRoute({
    @required this.builder,
    this.title,
    RouteSettings settings,
    this.maintainState = true,
    this.animationType,
  })  : assert(builder != null),
        assert(maintainState != null),
        assert(opaque),
        super(settings: settings, fullscreenDialog: true);

  /// Builds the primary contents of the route.
  final WidgetBuilder builder;

  final String title;

  final animationType;

  ValueNotifier<String> _previousTitle;

  ValueListenable<String> get previousTitle {
    assert(
      _previousTitle != null,
      'Cannot read the previousTitle for a route that has not yet been installed',
    );
    return _previousTitle;
  }

  @override
  void didChangePrevious(Route<dynamic> previousRoute) {
    final String previousTitleString =
        previousRoute is CupertinoPageRoute ? previousRoute.title : null;
    if (_previousTitle == null) {
      _previousTitle = ValueNotifier<String>(previousTitleString);
    } else {
      _previousTitle.value = previousTitleString;
    }
    super.didChangePrevious(previousRoute);
  }

  @override
  final bool maintainState;

  @override
  // A relatively rigorous eyeball estimation.
  Duration get transitionDuration => const Duration(milliseconds: 400);

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
    return previousRoute is CupertinoPageRoute;
  }

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return nextRoute is CupertinoPageRoute && !nextRoute.fullscreenDialog;
  }

  static bool isPopGestureInProgress(PageRoute<dynamic> route) {
    return route.navigator.userGestureInProgress;
  }

  bool get popGestureInProgress => isPopGestureInProgress(this);

  bool get popGestureEnabled => _isPopGestureEnabled(this);

  static bool _isPopGestureEnabled<T>(PageRoute<T> route) {
    // If there's nothing to go back to, then obviously we don't support
    // the back gesture.
    if (route.isFirst) return false;
    // If the route wouldn't actually pop if we popped it, then the gesture
    // would be really confusing (or would skip internal routes), so disallow it.
    if (route.willHandlePopInternally) return false;
    // If attempts to dismiss this route might be vetoed such as in a page
    // with forms, then do not allow the user to dismiss the route with a swipe.
    if (route.hasScopedWillPopCallback) return false;
    // Fullscreen dialogs aren't dismissible by back swipe.
    if (route.fullscreenDialog) return false;
    // If we're in an animation already, we cannot be manually swiped.
    if (route.animation.status != AnimationStatus.completed) return false;
    // If we're being popped into, we also cannot be swiped until the pop above
    // it completes. This translates to our secondary animation being
    // dismissed.
    if (route.secondaryAnimation.status != AnimationStatus.dismissed)
      return false;
    // If we're in a gesture already, we cannot start another.
    if (isPopGestureInProgress(route)) return false;

    // Looks like a back gesture would be welcome!
    return true;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final Widget result = Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: builder(context),
    );
    assert(() {
      if (result == null) {
        throw FlutterError(
            'The builder for route "${settings.name}" returned null.\n'
            'Route builders must never return null.');
      }
      return true;
    }());
    return result;
  }

  static Widget buildPageTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    RouteType routeType,
    Widget child,
  ) {
    if (routeType == RouteType.present) {
      return CupertinoFullscreenDialogTransition(
        primaryRouteAnimation: animation,
        child: child,
      );
    } else {
      return CupertinoPageTransition(
        primaryRouteAnimation: animation,
        secondaryRouteAnimation: secondaryAnimation,
        linearTransition: isPopGestureInProgress(route),
        child: child,
      );
    }
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return buildPageTransitions<T>(
        this, context, animation, secondaryAnimation, animationType, child);
  }

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}
