import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';

class AboutUsBox extends StatelessWidget {
  final String iconImageURL;
  final double iconSize;
  final String title;
  final String subtitle;
  final Function pressBox;

  AboutUsBox({
    @required this.iconImageURL,
    @required this.iconSize,
    this.title = "",
    this.subtitle = "",
    this.pressBox,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (this.pressBox != null) {
          this.pressBox();
        }
      },
      child: Container(
        width: R.appRatio.appWidth300,
        height: R.appRatio.appHeight80,
        decoration: BoxDecoration(
          color: R.colors.boxBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              offset: Offset(4.0, 4.0),
              color: R.colors.textShadow,
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: R.appRatio.appSpacing20,
              ),
              Image.asset(
                this.iconImageURL,
                width: this.iconSize,
                height: this.iconSize,
              ),
              SizedBox(
                width: R.appRatio.appSpacing20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    this.title,
                    style: TextStyle(
                      color: R.colors.contentText,
                      fontSize: R.appRatio.appFontSize18,
                    ),
                  ),
                  SizedBox(
                    height: R.appRatio.appSpacing5,
                  ),
                  Text(
                    this.subtitle,
                    style: TextStyle(
                      color: R.colors.orangeNoteText,
                      fontSize: R.appRatio.appFontSize14,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
