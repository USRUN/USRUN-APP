import 'package:flutter/cupertino.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/event_manager.dart';
import 'package:usrun/manager/team_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/model/object_filter.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/team.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_loading_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_selection_dialog.dart';

class RegisterLeaveEventUtil {
  static Future<Team> _chooseATeam(BuildContext context) async {
    List<Team> teamListOfUser = List();

    Response response = await TeamManager.getTeamByUser(UserManager.currentUser.userId);

    if(response.success && (response.object as List).isNotEmpty){
      teamListOfUser = response.object;
    }

    List<ObjectFilter> objFilterList = List();
    teamListOfUser.forEach((element) {
      objFilterList.add(ObjectFilter(
        name: element.teamName,
        iconURL: element.thumbnail,
        iconSize: 20,
        value: element,
      ));
    });

    int selectedIndex = await showCustomSelectionDialog(
      context,
      objFilterList,
      -1,
      title: R.strings.chooseTeamTitle,
      description: R.strings.chooseTeamDescription,
      enableObjectIcon: true,
      enableScrollBar: true,
      alwaysShowScrollBar: true,
    );

    return selectedIndex == null || selectedIndex < 0
        ? null
        : teamListOfUser[selectedIndex];
  }

  static Future<bool> handleRegisterAnEvent({
    @required BuildContext context,
    List<Event> eventList,
    int arrayIndex,
  }) async {
    /*
      + NOTE: The return value: true (eventList.removeAt(arrayIndex)), false (do nothing)
    */

    Team userTeam = await _chooseATeam(context);
    if (userTeam == null) return false;

    showCustomLoadingDialog(
      context,
      text: R.strings.processing,
    );

    bool result = false;

    Response<dynamic> response = await EventManager.joinEvent(eventList[arrayIndex].eventId,userTeam.id);

    if(response.success && response.errorCode == 0){
      result = true;
    };

    pop(context);

    if (result) {
      String message = R.strings.registerEventSuccessfully;
      message = message.replaceAll(
        "@@@",
        eventList[arrayIndex].eventName,
      );
      message = message.replaceAll("###", userTeam.teamName);

      await showCustomAlertDialog(
        context,
        title: R.strings.announcement,
        content: message,
        firstButtonText: R.strings.close.toUpperCase(),
        firstButtonFunction: () {
          pop(context);
        },
      );

      return true;
    } else {
      await showCustomAlertDialog(
        context,
        title: R.strings.error,
        content: R.strings.errorOccurred,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(context),
      );

      return false;
    }
  }

  static Future<bool> handleLeaveAnEvent({
    @required BuildContext context,
    List<Event> eventList,
    int arrayIndex,
  }) async {
    /*
      + NOTE: The return value: true (eventList.removeAt(arrayIndex)), false (do nothing)
    */

    bool isLeave = await showCustomAlertDialog(
      context,
      title: R.strings.caution,
      content: R.strings.eventLeaveDescription,
      firstButtonText: R.strings.leave.toUpperCase(),
      firstButtonFunction: () => pop(context, object: true),
      secondButtonText: R.strings.cancel.toUpperCase(),
      secondButtonFunction: () => pop(context),
    );

    if (isLeave == null) return false;

    showCustomLoadingDialog(
      context,
      text: R.strings.processing,
    );

    bool result = false;

    Response response = await EventManager.leaveEvent(eventList[arrayIndex].eventId);

    if(response.success && response.errorCode == 0){
      result = true;
    }

    pop(context);

    if (result) {
      String message = R.strings.leaveEventSuccessfully;
      message = message.replaceAll(
        "@@@",
        eventList[arrayIndex].eventName,
      );

      showCustomAlertDialog(
        context,
        title: R.strings.announcement,
        content: message,
        firstButtonText: R.strings.close.toUpperCase(),
        firstButtonFunction: () {
          pop(context);
        },
      );

      return true;
    } else {
      showCustomAlertDialog(
        context,
        title: R.strings.error,
        content: R.strings.errorOccurred,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(context),
      );

      return false;
    }
  }
}
