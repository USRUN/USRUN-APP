import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/util/image_cache_manager.dart';

class CustomGradientAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final int maxLines;
  final TextStyle titleStyle;
  final Widget titleWidget;
  final List<Widget> actions;
  final Brightness brightness;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final Function leadingFunction;
  final String leadingIconUrl;
  final double elevation;

  const CustomGradientAppBar({
    this.title = "",
    this.maxLines = 1,
    this.titleStyle,
    this.titleWidget,
    this.actions,
    this.brightness = Brightness.dark,
    this.automaticallyImplyLeading = false,
    this.centerTitle = true,
    this.leadingFunction,
    this.leadingIconUrl = "",
    this.elevation = 4,
  }) : assert(leadingIconUrl != null);

  Widget _renderAppBarTitle() {
    if (this.titleWidget != null) return this.titleWidget;
    if (this.title == null) return null;
    return Text(
      this.title,
      overflow: TextOverflow.ellipsis,
      textScaleFactor: 1.0,
      maxLines: this.maxLines,
      style: this.titleStyle ??
          TextStyle(
            color: Colors.white,
            fontSize: R.appRatio.appFontSize20,
            fontWeight: FontWeight.w600,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientAppBar(
      centerTitle: this.centerTitle,
      automaticallyImplyLeading: this.automaticallyImplyLeading,
      brightness: this.brightness,
      gradient: R.colors.uiGradient,
      title: _renderAppBarTitle(),
      actions: this.actions,
      elevation: this.elevation,
      leading: FlatButton(
        onPressed: () {
          if (leadingFunction != null) {
            leadingFunction();
          } else {
            pop(context);
          }
        },
        padding: EdgeInsets.all(0.0),
        splashColor: R.colors.lightBlurMajorOrange,
        textColor: Colors.white,
        child: ImageCacheManager.getImage(
          url: (this.leadingIconUrl.length == 0
              ? R.myIcons.appBarBackBtn
              : this.leadingIconUrl),
          width: 18,
          height: 18,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(R.appRatio.appBarHeight);
}
