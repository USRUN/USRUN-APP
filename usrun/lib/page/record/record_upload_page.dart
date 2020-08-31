import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/crypto.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/core/net/client.dart';
import 'package:usrun/manager/data_manager.dart';
import 'package:usrun/manager/event_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/page/record/activity_data.dart';
import 'package:usrun/page/record/record_bloc.dart';
import 'package:usrun/page/record/record_const.dart';
import 'package:usrun/page/record/record_data.dart';
import 'package:usrun/page/record/helper/record_helper.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/drop_down_menu/drop_down_menu.dart';
import 'package:usrun/widget/drop_down_menu/drop_down_object.dart';
import 'package:usrun/widget/input_field.dart';
import 'package:usrun/widget/line_button.dart';
import 'package:usrun/widget/my_info_box/normal_info_box.dart';
import 'package:usrun/widget/ui_button.dart';
import 'bloc_provider.dart';

// ignore: must_be_immutable
class RecordUploadPage extends StatefulWidget {
  RecordBloc bloc;
  ActivityData activity;
  MyStreamController<File> streamFile;

  RecordUploadPage(RecordBloc recordBloc) {
    bloc = recordBloc;
    //recordBloc.recordData.createTrack();
    activity = new ActivityData(recordBloc.recordData.trackId, bloc.recordData);
    streamFile = MyStreamController(defaultValue: null, activeBroadcast: true);
  }

  @override
  _RecordUploadPage createState() => _RecordUploadPage();
}

class _RecordUploadPage extends State<RecordUploadPage> {
  final double _buttonHeight = R.appRatio.appHeight60;

  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _descriptionController =
      new TextEditingController();

  final FocusNode _titleNode = FocusNode();
  final FocusNode _descriptionNode = FocusNode();

  void _unFocusAllFields() {
    _titleNode.unfocus();
    _descriptionNode.unfocus();
  }

  _buildStatsBox(String title, String value, String unit) {
    return NormalInfoBox(
      boxSize: MediaQuery.of(context).size.width * 0.3,
      id: title,
      firstTitleLine: title,
      secondTitleLine: unit,
      dataLine: value,
      disableGradientLine: true,
      boxRadius: 0,
      disableBoxShadow: true,
      pressBox: null,
    );
  }

  _buildStats() {
    RecordData data = widget.bloc.recordData;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          R.strings.stats,
          style: R.styles.labelStyle,
        ),
        SizedBox(
          height: R.appRatio.appSpacing15,
        ),
        Center(
          child: Container(
            height: deviceWidth * 0.6 + 2,
            width: deviceWidth * 0.9 + 3,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    height: deviceWidth * 0.6,
                    width: deviceWidth * 0.9,
                    color: R.colors.majorOrange,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildStatsBox(
                          R.strings.distance,
                          switchBetweenMeterAndKm(data.totalDistance)
                              .toString(),
                          R.strings.distanceUnit[
                              DataManager.getUserRunningUnit().index],
                        ),
                        _buildStatsBox(
                            R.strings.time,
                            (Duration(seconds: data.totalTime).toString())
                                .substring(0, 7),
                            R.strings.timeUnit),
                        _buildStatsBox(
                            R.strings.avgPace,
                            data.avgPace == -1
                                ? R.strings.na
                                : (Duration(seconds: data.avgPace.toInt())
                                        .toString())
                                    .substring(0, 7),
                            R.strings.avgPaceUnit)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildStatsBox(
                            R.strings.avgHeart,
                            data.avgHeart == -1
                                ? R.strings.na
                                : data.avgHeart.toString(),
                            R.strings.avgHeartUnit),
                        _buildStatsBox(
                            R.strings.calories,
                            data.calories == -1
                                ? R.strings.na
                                : data.calories.toString(),
                            R.strings.caloriesUnit),
                        _buildStatsBox(
                            R.strings.total,
                            data.totalStep == -1
                                ? R.strings.na
                                : data.totalStep.toString(),
                            R.strings.totalStepsUnit)
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildRunTitle() {
    if (_titleController.text.isEmpty) {
      _titleController.text = widget.activity.title;
    }
    return InputField(
      controller: _titleController,
      focusNode: _titleNode,
      labelTitle: R.strings.title,
      hintText: R.strings.titleHint,
    );
  }

  _buildDescription() {
    return InputField(
      controller: _descriptionController,
      focusNode: _descriptionNode,
      labelTitle: R.strings.yourDescription,
      enableMaxLines: true,
      hintText: R.strings.yourDescriptionHint,
    );
  }

  Widget buildPhotoPreview(context, index) {
    double deviceWidth = MediaQuery.of(context).size.width;
    File file = this.widget.activity.photos.length >= index + 1
        ? this.widget.activity.photos[index]
        : null;

    return GestureDetector(
      onTap: () {
        _unFocusAllFields();
        this.openSelectPhoto(context, index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: R.colors.appBackground,
          border: Border.all(
            color: R.colors.majorOrange,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        height: deviceWidth * 0.2,
        width: deviceWidth * 0.2,
        child: file != null
            ? Image.file(file,
                height: R.appRatio.appWidth1 * 80,
                width: R.appRatio.appWidth1 * 80,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low)
            : Icon(
                Icons.add,
                size: R.appRatio.appWidth1 * 40,
                color: R.colors.majorOrange,
              ),
      ),
    );
  }

  Future<void> openSelectPhoto(BuildContext context, int indexPhoto) async {
    try {
      Map<String, dynamic> imageResult =
          await getUserImageFile(CropStyle.rectangle, context);
      bool result = imageResult["result"];
      File file = imageResult["file"];
      if (result != null && result) {
        widget.activity.addPhotoFile(file, indexPhoto);
        this.widget.streamFile.add(file);
      }
    } catch (error) {
      print(error);
    }
  }

  void _getSelectedDropDownMenuItem<T>(T value) {
    widget.activity.recordData.eventId = value as int;
  }

  _buildEventDropDown() {
    List<DropDownObject<int>> dropDowMenuList = [];
    dropDowMenuList.add(DropDownObject<int>(value: -1, text: R.strings.no));
    EventManager.userOpeningEvents.forEach((event) {
      dropDowMenuList.add(
          DropDownObject<int>(value: event.eventId, text: event.eventName));
    });
    return DropDownMenu(
      errorEmptyData: R.strings.nothingToShow,
      enableFullWidth: true,
      labelTitle: R.strings.events,
      hintText: R.strings.events,
      enableHorizontalLabelTitle: false,
      onChanged: this._getSelectedDropDownMenuItem,
      items: dropDowMenuList,
      initialValue: dropDowMenuList[0].value,
    );
  }

  _buildPhotoPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(R.strings.yourPhotos, style: R.styles.labelStyle),
        SizedBox(
          height: R.appRatio.appSpacing15,
        ),
        StreamBuilder(
          stream: this.widget.streamFile.stream,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildPhotoPreview(context, 0),
                  SizedBox(width: R.appRatio.appSpacing15),
                  buildPhotoPreview(context, 1),
                  SizedBox(width: R.appRatio.appSpacing15),
                  buildPhotoPreview(context, 2),
                  SizedBox(width: R.appRatio.appSpacing15),
                  buildPhotoPreview(context, 3),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  _buildMapOptions() {
    return LineButton(
      mainText: R.strings.yourMaps,
      mainTextFontSize: R.appRatio.appFontSize18,
      mainTextStyle: R.styles.labelStyle,
      subText: R.strings.viewMapDescription,
      subTextFontSize: R.appRatio.appFontSize16,
      enableSplashColor: false,
      textPadding: EdgeInsets.all(0),
      enableSwitchButton: true,
      switchButtonOnTitle: "On",
      switchButtonOffTitle: "Off",
      initSwitchStatus: true,
      switchFunction: (state) {
        this.widget.activity.showMap = state;
      },
    );
  }

  _buildButtons() {
    Color backgroundColor = R.colors.boxBackground;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [R.styles.boxShadowAll],
      ),
      width: R.appRatio.deviceWidth,
      height: _buttonHeight,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: UIButton(
              color: R.colors.gray515151,
              fontWeight: FontWeight.bold,
              textColor: Colors.white,
              text: R.strings.discard.toUpperCase(),
              enableShadow: false,
              radius: 0,
              onTap: () {
                _unFocusAllFields();
                _clearRecordData();
              },
            ),
          ),
          Container(
            width: 1,
            height: _buttonHeight,
            child: VerticalDivider(
              color: R.colors.majorOrange,
              thickness: 1.0,
              width: 1,
            ),
          ),
          Expanded(
            child: UIButton(
              gradient: R.colors.uiGradient,
              fontWeight: FontWeight.bold,
              textColor: Colors.white,
              text: R.strings.upload.toUpperCase(),
              enableShadow: false,
              radius: 0,
              onTap: () {
                _unFocusAllFields();
                _uploadActivity();
              },
            ),
          ),
        ],
      ),
    );
  }

  _clearRecordData() async {
    showCustomAlertDialog(
      context,
      title: R.strings.notice,
      content: R.strings.discardActivity,
      firstButtonText: R.strings.ok.toUpperCase(),
      firstButtonFunction: () async {
        pop(this.context);
        await RecordHelper.removeFile();
        this.widget.bloc.resetAll();
        Navigator.pop(context);
      },
      secondButtonText: R.strings.cancel,
      secondButtonFunction: () {
        pop(this.context);
      },
    );
  }

  bool isUploading = false;

  _uploadActivity() async {
    if (isUploading == true) return;
    isUploading = true;
    //this.widget.activity.recordData = await RecordHelper.loadFromFile();
    Response<ActivityData> response = await upload();
    if (response.success) {
      await RecordHelper.removeFile();
      this.widget.bloc.resetAll();
      showCustomAlertDialog(
        context,
        title: R.strings.announcement,
        content: R.strings.successfullyUploaded,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () async {
          pop(this.context);
          await RecordHelper.removeFile();
          this.widget.bloc.resetAll();
          isUploading = false;
          Navigator.pop(context);
        },
      );
    } else {
      showCustomAlertDialog(
        context,
        title: R.strings.notice,
        content: R.strings.failToUpload,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () {
          isUploading = false;
          pop(this.context);
        },
      );
    }
  }

  Future<Response<ActivityData>> upload() async {
    //await this.widget.bloc.recordData.createTrack();
    String requestTime = DateTime.now().millisecondsSinceEpoch.toString();
    widget.activity.sig = UsrunCrypto.buildActivitySig(requestTime);
    this.widget.activity.title = _titleController.text;
    this.widget.activity.description = _descriptionController.text;
    var params =
        RecordHelper.generateParamsForRequest(widget.activity, requestTime);
    Response<Map<String, dynamic>> response =
        await Client.post<Map<String, dynamic>, Map<String, dynamic>>(
            '/activity/createUserActivity', params);

    Response<ActivityData> result = Response();

    if (response.success) {
      result.success = true;
    } else {
      result.success = false;
      result.errorCode = response.errorCode;
    }
    return result;
  }

  void getEventOfUser() async {
    await EventManager.getUserEvents(UserManager.currentUser.userId);
  }

  @override
  Widget build(BuildContext context) {
    getEventOfUser();

    var appBar = CustomGradientAppBar(
      title: R.strings.uploadActivity,
      leadingFunction: () {
        this.widget.bloc.updateRecordStatus(RecordState.StatusStop);
        pop(context);
      },
    );

    Widget _smallElement = Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: R.colors.appBackground,
      appBar: appBar,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: R.appRatio.appSpacing15,
              right: R.appRatio.appSpacing15,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: R.appRatio.appSpacing20,
                  ),
                  _buildStats(),
                  SizedBox(
                    height: R.appRatio.appSpacing20,
                  ),
                  _buildRunTitle(),
                  SizedBox(
                    height: R.appRatio.appSpacing20,
                  ),
                  _buildDescription(),
                  SizedBox(
                    height: R.appRatio.appSpacing20,
                  ),
                  _buildEventDropDown(),
                  SizedBox(
                    height: R.appRatio.appSpacing20,
                  ),
                  _buildPhotoPicker(),
                  SizedBox(
                    height: R.appRatio.appSpacing20,
                  ),
                  _buildMapOptions(),
                  SizedBox(
                    height: R.appRatio.appSpacing20 + _buttonHeight,
                  ),
                ],
              ),
            ),
          ),
          _buildButtons(),
        ],
      ),
    );

    Widget _bigElement = WillPopScope(
      onWillPop: () async {
        this.widget.bloc.updateRecordStatus(RecordState.StatusStop);
        return true;
      },
      child: GestureDetector(
        onTap: _unFocusAllFields,
        child: _smallElement,
      ),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
      child: _bigElement,
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return false;
      },
    );
  }
}
