import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/util/string_utils.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';

class EventPosterPage extends StatelessWidget {
  final String eventName;
  final String posterURL;

  const EventPosterPage({
    @required this.eventName,
    @required this.posterURL,
  });

  Widget _renderNameLine() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: R.appRatio.appSpacing10),
        Padding(
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing5,
            right: R.appRatio.appSpacing5,
          ),
          child: Text(
            this.eventName,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: R.colors.majorOrange,
              fontWeight: FontWeight.bold,
              fontSize: R.appRatio.appFontSize18,
            ),
          ),
        ),
        SizedBox(height: R.appRatio.appSpacing10),
        Divider(
          height: 1,
          thickness: 1,
          color: R.colors.majorOrange,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String appTitle = StringUtils.uppercaseFirstLetterEachWord(
      content: R.strings.eventPoster,
      pattern: " ",
    );

    return Scaffold(
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(
        title: appTitle,
      ),
      body: Container(
        width: R.appRatio.deviceWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _renderNameLine(),
            SizedBox(height: R.appRatio.appSpacing15),
            Expanded(
              child: ImageCacheManager.getImage(
                  url: this.posterURL,
                  width: R.appRatio.deviceWidth,
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter),
            ),
          ],
        ),
      ),
    );
  }
}
