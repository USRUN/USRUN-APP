import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/data_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/util/common_utils.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/util/toast_utils.dart';
import 'package:usrun/widget/custom_dialog/custom_loading_dialog.dart';
import 'package:usrun/widget/ui_button.dart';

class HcmusEmailVerification extends StatefulWidget {
  @override
  _HcmusEmailVerificationState createState() => _HcmusEmailVerificationState();
}

class _HcmusEmailVerificationState extends State<HcmusEmailVerification> {
  FocusNode _codeFocusNode;
  TextEditingController _textCodeController;
  String num1, num2, num3, num4, num5, num6;
  int _rawSeconds = 300;
  int _remainingSeconds = 300;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    num1 = num2 = num3 = num4 = num5 = num6 = "";
    _textCodeController = TextEditingController();
    _codeFocusNode = FocusNode();
    CommonUtils.delayRequestFocusNode(
      focusNode: _codeFocusNode,
    );
    _createOTPCode();
    _startTimer();
  }

  @override
  void dispose() {
    _codeFocusNode.dispose();
    _textCodeController.dispose();
    _stopTimer();
    super.dispose();
  }

  Future<void> _createOTPCode() async {
    await UserManager.resendOTP();
  }

  void _startTimer() {
    if (!mounted) return;
    _stopTimer();

    int startTimeCountdown = DateTime.now().millisecondsSinceEpoch;
    DataManager.setHEVCountDownTime(startTimeCountdown);

    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        this._remainingSeconds -= 1;
      });
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void _showLoading() {
    if (!mounted) return;
    showCustomLoadingDialog(context);
  }

  void _hideLoading() {
    if (!mounted) return;
    pop(context);
  }

  void _onChangedCodeBoxData(String data) async {
    switch (data.length) {
      case 0:
        setState(() {
          this.num1 = "";
          this.num2 = "";
          this.num3 = "";
          this.num4 = "";
          this.num5 = "";
          this.num6 = "";
        });
        break;
      case 1:
        setState(() {
          this.num2 = "";
          this.num1 = data.substring(data.length - 1);
        });
        break;
      case 2:
        setState(() {
          this.num3 = "";
          this.num2 = data.substring(data.length - 1);
        });
        break;
      case 3:
        setState(() {
          this.num4 = "";
          this.num3 = data.substring(data.length - 1);
        });
        break;
      case 4:
        setState(() {
          this.num5 = "";
          this.num4 = data.substring(data.length - 1);
        });
        break;
      case 5:
        setState(() {
          this.num6 = "";
          this.num5 = data.substring(data.length - 1);
        });
        break;
      case 6:
        setState(() {
          this.num6 = data.substring(data.length - 1);
          _verifyHcmusEmail(data);
        });
        break;
      default:
        setState(() {
          this._textCodeController.text = data.substring(0, data.length - 1);
          this._textCodeController.selection = TextSelection(
              baseOffset: _textCodeController.value.text.length,
              extentOffset: _textCodeController.value.text.length);
        });
        break;
    }
  }

  Future<void> _verifyHcmusEmail(String code) async {
    _codeFocusNode.unfocus();
    _showLoading();

    String resultCode = "SUCCESS";
    Response response = await UserManager.verifyAccount(code);

    _hideLoading();

    if (response.errorCode == 1004) {
      resultCode = "INVALID_CODE";
    } else if (response.errorCode != -1) {
      resultCode = "ERROR_OCCURRED";
    }

    if (resultCode.compareTo("INVALID_CODE") == 0) {
      showToastDefault(
        msg: R.strings.settingsAccountVerifyHcmusEmailInvalidCode,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      _codeFocusNode.requestFocus();
      return;
    }

    if (resultCode.compareTo("ERROR_OCCURRED") == 0) {
      showToastDefault(
        msg: R.strings.errorOccurred,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
      _codeFocusNode.requestFocus();
      return;
    }

    if (resultCode.compareTo("SUCCESS") == 0) {
      User newUser = UserManager.currentUser;
      newUser.hcmus = true;
      UserManager.currentUser.copy(newUser);
      DataManager.saveUser(newUser);

      Future.delayed(Duration(milliseconds: 600), () {
        pop(context, object: true);
      });
    }
  }

  Widget _renderBodyContent() {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ImageCacheManager.getImage(
                    url: R.images.logoText,
                    width: 150,
                  ),
                  SizedBox(height: 15),
                  Text(
                    R.strings.settingsAccountVerifyHcmusEmailTitle
                        .toUpperCase(),
                    textScaleFactor: 1.0,
                    maxLines: 1,
                    style: TextStyle(
                      color: Color(0xFFF26522),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 24,
                bottom: 12,
                left: 15,
                right: 15,
              ),
              child: Text(
                R.strings.settingsAccountVerifyHcmusEmailDescription,
                textAlign: TextAlign.center,
                textScaleFactor: 1.0,
                softWrap: true,
                style: TextStyle(
                  color: R.colors.contentText,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildTextNumber(num1),
                  _buildTextNumber(num2),
                  _buildTextNumber(num3),
                  _buildTextNumber(num4),
                  _buildTextNumber(num5),
                  _buildTextNumber(num6),
                ],
              ),
            ),
            _buildCountDownOrResendCode(),
            Container(
              width: 0,
              height: 0,
              margin: EdgeInsets.only(top: 10),
              child: TextField(
                controller: _textCodeController,
                focusNode: _codeFocusNode,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                showCursor: false,
                cursorColor: R.colors.contentText,
                cursorWidth: 0,
                style: TextStyle(
                  color: (R.currentAppTheme == AppTheme.DARK
                      ? Color(0xFF121212)
                      : Colors.white),
                ),
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                maxLines: 1,
                onChanged: (data) {
                  _onChangedCodeBoxData(data);
                },
                onSubmitted: (data) {
                  FocusScope.of(context).requestFocus(_codeFocusNode);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderBackButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: 90,
        height: 35,
        padding: EdgeInsets.only(left: 10),
        child: FlatButton(
          onPressed: () {
            if (_codeFocusNode.hasFocus &&
                MediaQuery.of(context).viewInsets.bottom > 0.0) {
              _codeFocusNode.unfocus();
              Future.delayed(Duration(milliseconds: 300), () {
                pop(context);
              });
              return;
            }
            pop(context);
          },
          padding: EdgeInsets.all(0.0),
          splashColor: R.colors.lightBlurMajorOrange,
          textColor: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ImageCacheManager.getImage(
                url: R.myIcons.chevronLeftIcon,
                width: 14,
                height: 14,
                color: R.colors.grayButtonColor,
              ),
              SizedBox(width: 6),
              Text(
                R.strings.back,
                textScaleFactor: 1.0,
                style: TextStyle(
                  color: R.colors.contentText,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: R.colors.appBackground,
      appBar: PreferredSize(
        child: Container(),
        preferredSize: Size(0, 0),
      ),
      body: Container(
        height: R.appRatio.deviceHeight,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            ImageCacheManager.getImage(
              url: R.images.pageBackground,
            ),
            // Body content
            _renderBodyContent(),
            // Back button
            _renderBackButton(),
          ],
        ),
      ),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
        child: _buildElement,
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        });
  }

  Future<void> doResendCode() async {
    this._stopTimer();
    this._textCodeController.text = "";
    setState(() {
      this.num1 = "";
      this.num2 = "";
      this.num3 = "";
      this.num4 = "";
      this.num5 = "";
      this.num6 = "";
    });

    _showLoading();
    await _createOTPCode();
    _hideLoading();

    DataManager.setHEVCountDownTime(DateTime.now().millisecondsSinceEpoch);
    setState(() {
      this._remainingSeconds = _rawSeconds;
      this._startTimer();
    });
    _codeFocusNode.requestFocus();
  }

  Widget _buildCountDownOrResendCode() {
    if (this._remainingSeconds <= 0) {
      _codeFocusNode.unfocus();
      return Container(
        margin: EdgeInsets.fromLTRB(15, 20, 15, 15),
        child: UIButton(
          onTap: doResendCode,
          textColor: Colors.white,
          text:
              R.strings.settingsAccountVerifyHcmusEmailResendCode.toUpperCase(),
          gradient: R.colors.uiGradient,
          textSize: 14,
          radius: 5.0,
          height: 40,
          boxShadow: BoxShadow(
            offset: Offset(2.0, 2.0),
            blurRadius: 2.0,
            color: (R.currentAppTheme == AppTheme.LIGHT
                ? Color.fromRGBO(0, 0, 0, 0.2)
                : Color.fromRGBO(255, 255, 255, 0.2)),
          ),
        ),
      );
    }

    String remainingTime =
        R.strings.settingsAccountVerifyHcmusEmailTimeRemaining;
    remainingTime = remainingTime.replaceAll(
      "@#@#@#",
      this._remainingSeconds.toString(),
    );

    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Text(
        remainingTime,
        textScaleFactor: 1.0,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: R.colors.contentText,
        ),
      ),
    );
  }

  Widget _buildTextNumber(String label) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      child: FlatButton(
        onPressed: () {
          if (_remainingSeconds > 0) {
            SystemChannels.textInput.invokeMethod('TextInput.show');
          }
        },
        splashColor: R.colors.lightBlurMajorOrange,
        textColor: Colors.white,
        padding: EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          side: BorderSide(
            color: R.colors.grayABABAB,
            width: 1,
          ),
        ),
        child: Text(
          label,
          textScaleFactor: 1.0,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: R.colors.contentText,
          ),
        ),
      ),
    );
  }
}
