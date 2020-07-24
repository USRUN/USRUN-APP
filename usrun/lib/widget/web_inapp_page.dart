import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebInAppPage extends StatefulWidget {
  final String webUrl;
  final double webBodyRadius;
  final BoxShadow webBodyBoxShadow;
  final BoxBorder webBodyBoxBorder;
  final Color webBodyColor;
  final EdgeInsets webBodyMargin;
  final EdgeInsets webBodyPadding;
  final bool enableAppBar;
  final Color appBarBackgroundColor;
  final String appBarTitle;
  final bool appBarCenterTitle;
  final TextStyle appBarTextStyle;
  final Brightness appBarBrightness;
  final Gradient appBarBackgroundGradient;
  final bool hasLoadingIndicator;
  final List<JavascriptChannel> jsChannels;
  final bool clearCacheWhenWebViewCreated;
  final Color scaffoldBackgroundColor;

  WebInAppPage({
    Key key,
    @required this.webUrl,
    this.webBodyRadius = 0.0,
    this.webBodyBoxShadow = const BoxShadow(
      offset: Offset(0.0, 0.0),
      blurRadius: 0.0,
      color: Colors.transparent,
    ),
    this.webBodyBoxBorder,
    this.webBodyColor,
    this.webBodyMargin = const EdgeInsets.all(0),
    this.webBodyPadding = const EdgeInsets.all(0),
    this.enableAppBar = true,
    this.appBarBackgroundColor,
    this.appBarTitle = "",
    this.appBarCenterTitle = true,
    this.appBarTextStyle,
    this.appBarBrightness,
    this.appBarBackgroundGradient,
    this.hasLoadingIndicator = true,
    this.jsChannels,
    this.clearCacheWhenWebViewCreated = false,
    this.scaffoldBackgroundColor = Colors.white,
  })  : assert(appBarTitle != null &&
            appBarCenterTitle != null &&
            webUrl.length != 0 &&
            hasLoadingIndicator != null &&
            clearCacheWhenWebViewCreated != null &&
            enableAppBar != null &&
            scaffoldBackgroundColor != null &&
            webBodyRadius != null &&
            webBodyRadius >= 0.0),
        super(key: key);

  @override
  _WebInAppPageState createState() => _WebInAppPageState();
}

class _WebInAppPageState extends State<WebInAppPage> {
  final CookieManager _cookieManager = CookieManager();

  bool _isLoading;
  double _loadingValue;
  bool _canGoBack;
  bool _canForward;
  WebViewController _wvController;

  @override
  void initState() {
    super.initState();
    _canGoBack = false;
    _canForward = false;
    _isLoading = false;
    _loadingValue = 0.0;
  }

  Future<void> reloadWebView() async {
    await _wvController.reload();
  }

  Future<bool> canGoBack() async {
    return await _wvController.canGoBack();
  }

  Future<void> goBack() async {
    await _wvController.goBack();
  }

  Future<bool> canGoForward() async {
    return await _wvController.canGoForward();
  }

  Future<void> goForward() async {
    await _wvController.goForward();
  }

  Future<void> scrollTo(int x, int y) async {
    await _wvController.scrollTo(x, y);
  }

  Future<String> evaluateJs(String javascriptString) async {
    // Another way not use evaludateJavascript:
    // ==> loadUrl: "javascript:updateNotificationToken('$token')"
    if (javascriptString.length == 0) return null;
    return await _wvController.evaluateJavascript(javascriptString);
  }

  Future<List<String>> getAllCookies() async {
    final String cookies =
        await _wvController.evaluateJavascript('document.cookie');
    List<String> cookieList = cookies.split(';');
    return cookieList;
  }

  Future<void> clearCache() async {
    await _wvController.clearCache();
  }

  void clearAllCookies() async {
    await _cookieManager.clearCookies();
  }

  void _updateLoading(bool status) {
    if (!widget.hasLoadingIndicator) return;
    if (_isLoading == status) return;
    if (!mounted) return;
    if (status) {
      setState(() {
        _isLoading = status;
      });
      Future.delayed(Duration(milliseconds: 50), () {
        setState(() {
          _loadingValue = 0.25;
        });
      });
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          _loadingValue = 0.45;
        });
      });
      Future.delayed(Duration(milliseconds: 150), () {
        setState(() {
          _loadingValue = 0.65;
        });
      });
    } else {
      setState(() {
        _loadingValue = 1.0;
      });
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          _isLoading = status;
          _loadingValue = 0.0;
        });
      });
    }
  }

  void _updateBackButtonState({bool state: false}) {
    if (!mounted) return;
    if (_canGoBack == state) return;
    setState(() {
      _canGoBack = state;
    });
  }

  void _updateForwardButtonState({bool state: false}) {
    if (!mounted) return;
    if (_canForward == state) return;
    setState(() {
      _canForward = state;
    });
  }

  Future<void> _checkCanGoBackOrForward() async {
    bool res = await canGoBack();
    _updateBackButtonState(state: res);
    res = await canGoForward();
    _updateForwardButtonState(state: res);
  }

  Widget _renderWebBackButton() {
    return Container(
      width: 40,
      child: FlatButton(
        onPressed: () async {
          await goBack();
          await _checkCanGoBackOrForward();
        },
        padding: EdgeInsets.all(0.0),
        splashColor: R.colors.lightBlurMajorOrange,
        textColor: Colors.white,
        child: ImageCacheManager.getImage(
          url: R.myIcons.chevronLeftIcon,
          width: R.appRatio.appAppBarIconSize,
          height: R.appRatio.appAppBarIconSize,
          color: (_canGoBack ? Colors.white : R.colors.gray515151),
        ),
      ),
    );
  }

  Widget _renderWebForwardButton() {
    return Container(
      width: 40,
      child: FlatButton(
        onPressed: () async {
          await goForward();
          await _checkCanGoBackOrForward();
        },
        padding: EdgeInsets.all(0.0),
        splashColor: R.colors.lightBlurMajorOrange,
        textColor: Colors.white,
        child: ImageCacheManager.getImage(
          url: R.myIcons.chevronRightIcon,
          width: R.appRatio.appAppBarIconSize,
          height: R.appRatio.appAppBarIconSize,
          color: (_canForward ? Colors.white : R.colors.gray515151),
        ),
      ),
    );
  }

  Widget _renderWebReloadButton() {
    return Container(
      width: 40,
      child: FlatButton(
        onPressed: () async {
          await reloadWebView();
          await scrollTo(0, 0);
        },
        padding: EdgeInsets.all(0.0),
        splashColor: R.colors.lightBlurMajorOrange,
        textColor: Colors.white,
        child: ImageCacheManager.getImage(
          url: R.myIcons.repeatIcon,
          width: R.appRatio.appAppBarIconSize - 1,
          height: R.appRatio.appAppBarIconSize - 1,
        ),
      ),
    );
  }

  Widget _renderAppBar() {
    if (!widget.enableAppBar) {
      return PreferredSize(
        preferredSize: Size(0, 0),
        child: Container(),
      );
    }

    if (widget.appBarBackgroundGradient != null) {
      return GradientAppBar(
        title: Text(
          widget.appBarTitle,
          textScaleFactor: 1.0,
          style: widget.appBarTextStyle ??
              TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: widget.appBarCenterTitle,
        brightness: widget.appBarBrightness ?? Brightness.dark,
        gradient: widget.appBarBackgroundGradient,
        leading: FlatButton(
          onPressed: () => pop(context),
          padding: EdgeInsets.all(0.0),
          splashColor: R.colors.lightBlurMajorOrange,
          textColor: Colors.white,
          child: ImageCacheManager.getImage(
            url: R.myIcons.appBarBackBtn,
            width: R.appRatio.appAppBarIconSize,
            height: R.appRatio.appAppBarIconSize,
          ),
        ),
        actions: <Widget>[
          _renderWebBackButton(),
          _renderWebForwardButton(),
          _renderWebReloadButton(),
        ],
      );
    }

    return AppBar(
      title: Text(
        widget.appBarTitle,
        textScaleFactor: 1.0,
        style: widget.appBarTextStyle ??
            TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
      ),
      centerTitle: widget.appBarCenterTitle,
      brightness: widget.appBarBrightness ?? Brightness.dark,
      backgroundColor: widget.appBarBackgroundColor ?? R.colors.majorOrange,
      leading: FlatButton(
        onPressed: () => pop(context),
        padding: EdgeInsets.all(0.0),
        splashColor: R.colors.lightBlurMajorOrange,
        textColor: Colors.white,
        child: ImageCacheManager.getImage(
          url: R.myIcons.appBarBackBtn,
          width: R.appRatio.appAppBarIconSize,
          height: R.appRatio.appAppBarIconSize,
        ),
      ),
      actions: <Widget>[
        _renderWebBackButton(),
        _renderWebForwardButton(),
        _renderWebReloadButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Scaffold(
      appBar: _renderAppBar(),
      backgroundColor: widget.scaffoldBackgroundColor,
      body: Container(
        margin: widget.webBodyMargin,
        padding: widget.webBodyPadding,
        decoration: BoxDecoration(
          color: widget.webBodyColor,
          border: widget.webBodyBoxBorder,
          boxShadow: [widget.webBodyBoxShadow],
          borderRadius: BorderRadius.all(Radius.circular(widget.webBodyRadius)),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(widget.webBodyRadius),
              ),
              child: WebView(
                initialUrl: widget.webUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) async {
                  _updateLoading(true);
                  _wvController = webViewController;
                  if (widget.clearCacheWhenWebViewCreated) {
                    await clearCache();
                  }
                },
                onPageStarted: (url) {
                  _updateLoading(true);
                },
                onPageFinished: (value) async {
                  _updateLoading(false);
                  await _checkCanGoBackOrForward();
                },
                javascriptChannels:
                    (widget.jsChannels != null && widget.jsChannels.length != 0
                        ? widget.jsChannels.toSet()
                        : null),
              ),
            ),
            (_isLoading
                ? LinearProgressIndicator(
                    backgroundColor: R.colors.blurMajorOrange,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(R.colors.majorOrange),
                    value: _loadingValue,
                  )
                : Container()),
          ],
        ),
      ),
    );

    _buildElement = WillPopScope(
      onWillPop: () async {
        bool _canGoBack = await canGoBack();
        if (_canGoBack) {
          goBack();
          return Future.value(false);
        } else {
          pop(context, object: true);
          return Future.value(true);
        }
      },
      child: _buildElement,
    );

    return _buildElement;
  }
}
