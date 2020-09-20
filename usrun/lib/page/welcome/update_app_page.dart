
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/widget/ui_button.dart';

class UpdateAppPage extends StatelessWidget{

  final String title = R.strings.updateAvailable;
  final double _spacing = R.appRatio.appSpacing20;
  final double _buttonHeight = R.appRatio.appHeight60.roundToDouble();

  Widget _renderTitle() {
    return Container(
      margin: EdgeInsets.only(
        top: R.appRatio.appSpacing15,
        bottom: R.appRatio.appSpacing15,
      ),
      child: Text(
        title,
        textScaleFactor: 1,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: R.colors.majorOrange,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _renderImage() {
    return ImageCacheManager.getImage(
      url: R.images.updateAppImg,
      height: R.appRatio.appHeight280,
      width: double.infinity,
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        primary: false,
        appBar: PreferredSize(
          child: Container(),
          preferredSize: Size(0, 0),
        ),
        backgroundColor: Colors.white,
        body: Container(
          height: R.appRatio.deviceHeight,
          margin: EdgeInsets.only(
            left: _spacing,
            right: _spacing,
          ),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _renderImage(),
                SizedBox(height: 20,),
                _renderTitle(),
                SizedBox(height: 20,),
                UIButton(
                  gradient: R.colors.uiGradient,
                  fontWeight: FontWeight.bold,
                  textColor: Colors.white,
                  width: R.appRatio.appWidth200,
                  text: R.strings.update.toUpperCase(),
                  enableShadow: false,
                  radius: 0,
                  height: _buttonHeight,
                  onTap: () {
                    StoreRedirect.redirect(
                      androidAppId: R.androidAppId,
                      iOSAppId: R.iOSAppId,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
  }
}