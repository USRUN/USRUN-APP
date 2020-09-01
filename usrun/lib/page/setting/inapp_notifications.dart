import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/line_button.dart';

class InAppNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(title: R.strings.inAppNotifications),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: R.appRatio.appSpacing20,
              ),
              /* 
                  ACTIVITIES
              */
              Padding(
                padding: EdgeInsets.only(
                  left: R.appRatio.appSpacing15,
                ),
                child: Text(
                  R.strings.notiActLabel,
                  textAlign: TextAlign.start,
                  style: R.styles.shadowLabelStyle,
                ),
              ),
              LineButton(
                mainText: R.strings.notiActReactionTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.notiActReactionSubtitle,
                subTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                enableSwitchButton: true,
                switchButtonOnTitle: "On",
                switchButtonOffTitle: "Off",
                initSwitchStatus: true,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
              LineButton(
                mainText: R.strings.notiActDiscussionTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.notiActDiscussionSubtitle,
                subTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                enableSwitchButton: true,
                switchButtonOnTitle: "On",
                switchButtonOffTitle: "Off",
                initSwitchStatus: true,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
              LineButton(
                mainText: R.strings.notiActShareTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.notiActShareSubtitle,
                subTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                enableSwitchButton: true,
                switchButtonOnTitle: "On",
                switchButtonOffTitle: "Off",
                initSwitchStatus: true,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
              LineButton(
                mainText: R.strings.notiActMentionInDiscussionTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.notiActMentionInDiscussionSubtitle,
                subTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                enableSwitchButton: true,
                switchButtonOnTitle: "On",
                switchButtonOffTitle: "Off",
                initSwitchStatus: false,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing25,
              ),
              /*
                  EVENTS
              */
              Padding(
                padding: EdgeInsets.only(
                  left: R.appRatio.appSpacing15,
                ),
                child: Text(
                  R.strings.notiEvtLabel,
                  textAlign: TextAlign.start,
                  style: R.styles.shadowLabelStyle,
                ),
              ),
              LineButton(
                mainText: R.strings.notiEvtInfoTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.notiEvtInfoSubtitle,
                subTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                enableSwitchButton: true,
                switchButtonOnTitle: "On",
                switchButtonOffTitle: "Off",
                initSwitchStatus: true,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
              LineButton(
                mainText: R.strings.notiEvtReminder6HTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.notiEvtReminder6HSubtitle,
                subTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                enableSwitchButton: true,
                switchButtonOnTitle: "On",
                switchButtonOffTitle: "Off",
                initSwitchStatus: true,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
              LineButton(
                mainText: R.strings.notiEvtReminder24HTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.notiEvtReminder24HSubtitle,
                subTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                enableSwitchButton: true,
                switchButtonOnTitle: "On",
                switchButtonOffTitle: "Off",
                initSwitchStatus: true,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
              LineButton(
                mainText: R.strings.notiEvtRankChangesTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.notiEvtRankChangesSubtitle,
                subTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                enableSwitchButton: true,
                switchButtonOnTitle: "On",
                switchButtonOffTitle: "Off",
                initSwitchStatus: true,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
              LineButton(
                mainText: R.strings.notiEvtInvitationTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.notiEvtInvitationSubtitle,
                subTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                enableSwitchButton: true,
                switchButtonOnTitle: "On",
                switchButtonOffTitle: "Off",
                initSwitchStatus: true,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing25,
              ),
              /*
                  FOLLOWING & FOLLOWERS
              */
              Padding(
                padding: EdgeInsets.only(
                  left: R.appRatio.appSpacing15,
                ),
                child: Text(
                  R.strings.notiFFLabel,
                  textAlign: TextAlign.start,
                  style: R.styles.shadowLabelStyle,
                ),
              ),
              LineButton(
                mainText: R.strings.notiFFNewFollowersTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.notiFFNewFollowersSubtitle,
                subTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                enableSwitchButton: true,
                switchButtonOnTitle: "On",
                switchButtonOffTitle: "Off",
                initSwitchStatus: true,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
              LineButton(
                mainText: R.strings.notiFFNewActivitiesTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.notiFFNewActivitiesSubtitle,
                subTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                enableSwitchButton: true,
                switchButtonOnTitle: "On",
                switchButtonOffTitle: "Off",
                initSwitchStatus: true,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
              SizedBox(
                height: R.appRatio.appSpacing25,
              ),
              /*
                  TEAMS
              */
              Padding(
                padding: EdgeInsets.only(
                  left: R.appRatio.appSpacing15,
                ),
                child: Text(
                  R.strings.notiTMLabel,
                  textAlign: TextAlign.start,
                  style: R.styles.shadowLabelStyle,
                ),
              ),
              LineButton(
                mainText: R.strings.notiTMInvitationTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.notiTMInvitationSubtitle,
                subTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                enableSwitchButton: true,
                switchButtonOnTitle: "On",
                switchButtonOffTitle: "Off",
                initSwitchStatus: true,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
              LineButton(
                mainText: R.strings.notiTMPlansTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.notiTMPlansSubtitle,
                subTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: true,
                enableSwitchButton: true,
                switchButtonOnTitle: "On",
                switchButtonOffTitle: "Off",
                initSwitchStatus: true,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
              LineButton(
                mainText: R.strings.notiTMPostsTitle,
                mainTextFontSize: R.appRatio.appFontSize18,
                subText: R.strings.notiTMPostsSubtitle,
                subTextFontSize: R.appRatio.appFontSize16,
                textPadding: EdgeInsets.all(15),
                enableBottomUnderline: false,
                enableSwitchButton: true,
                switchButtonOnTitle: "On",
                switchButtonOffTitle: "Off",
                initSwitchStatus: true,
                switchFunction: (state) {
                  // TODO: Implementing here
                  print('Current State of SWITCH IS: $state');
                },
              ),
            ],
          ),
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
}
