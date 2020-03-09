import 'package:flutter/material.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:usrun/core/R.dart';

class LoadingDotStyle01 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: R.appRatio.appIconSize5,
        height: R.appRatio.appIconSize5,
        decoration: BoxDecoration(
          gradient: R.colors.uiGradient,
        ),
      ),
    );
  }
}

class LoadingDotStyle02 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: NutsActivityIndicator(
        activeColor: Colors.red,
        inactiveColor: Colors.orange,
        tickCount: 12,
        relativeWidth: 0.8,
        radius: 15,
      ),
    );
  }
}
