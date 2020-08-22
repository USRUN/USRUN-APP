import 'package:flutter/cupertino.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/model/object_filter.dart';
import 'package:usrun/model/team.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_complex_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_loading_dialog.dart';
import 'package:usrun/widget/custom_dialog/custom_selection_dialog.dart';
import 'package:usrun/widget/input_field.dart';

class RegisterLeaveEventUtil {
  static Future<Team> _chooseATeam(BuildContext context) async {
    // TODO: API get team list of users
    List<Team> teamListOfUser = [
      Team(
        id: 1,
        teamName: "Trường Đại học Khoa học Tự nhiên",
        thumbnail: R.images.avatarQuocTK,
      ),
      Team(
        id: 2,
        teamName: "Công ty Cổ phần Tự Nghĩa",
        thumbnail: R.images.avatarHuyTA,
      ),
      Team(
        id: 3,
        teamName: "ABCOL Corporation",
        thumbnail: R.images.avatarNgocVTT,
      ),
    ];

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

    // TODO: Put your code here
    // result: true (Registering successfully), false (Registering fail)
    bool result = await Future.delayed(Duration(milliseconds: 2500), () {
      print("[EVENT_INFO_LINE] Finish processing about registering an event");
      return true;
    });

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
    TextEditingController confirmController = TextEditingController();
    String description = R.strings.eventLeaveDescription;
    description = description.replaceAll(
      '@@@',
      eventList[arrayIndex].eventName,
    );
    bool isLeave = await showCustomComplexDialog<bool>(
      context,
      headerContent: R.strings.caution,
      descriptionContent: description,
      firstButtonText: R.strings.leave.toUpperCase(),
      firstButtonFunction: () {
        String text = confirmController.text.trim().toLowerCase();
        if (text.compareTo(R.strings.confirm.toLowerCase()) == 0) {
          pop(context, object: true);
        }
      },
      secondButtonText: R.strings.cancel.toUpperCase(),
      secondButtonFunction: () => pop(context),
      inputFieldList: [
        InputField(
          controller: confirmController,
          enableFullWidth: true,
          hintText: R.strings.confirm.toLowerCase(),
          autoFocus: true,
          hintStyle: TextStyle(
            fontSize: R.appRatio.appFontSize18,
            color: R.colors.grayABABAB,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );

    if (isLeave == null) return false;

    showCustomLoadingDialog(
      context,
      text: R.strings.processing,
    );

    // TODO: Put your code here
    // result: true (Leaving successfully), false (Leaving fail)
    bool result = await Future.delayed(Duration(milliseconds: 2500), () {
      print("[EVENT_INFO_LINE] Finish processing about leaving an event");
      return true;
    });

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
