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
import 'package:usrun/model/response.dart';
import 'package:usrun/page/record/activity_data.dart';
import 'package:usrun/page/record/record_bloc.dart';
import 'package:usrun/page/record/record_const.dart';
import 'package:usrun/page/record/record_data.dart';
import 'package:usrun/page/record/helper/record_helper.dart';
import 'package:usrun/util/date_time_utils.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/drop_down_menu/drop_down_menu.dart';
import 'package:usrun/widget/drop_down_menu/drop_down_object.dart';
import 'package:usrun/widget/input_field.dart';
import 'package:usrun/widget/line_button.dart';
import 'package:usrun/widget/my_info_box/normal_info_box.dart';
import 'package:usrun/widget/ui_button.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'bloc_provider.dart';

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
    );
  }

  _buildStats() {
    RecordData data = widget.bloc.recordData;
    double deviceWidth = MediaQuery.of(context).size.width;
    return (Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: R.appRatio.appWidth1 * 25,
            left: R.appRatio.appSpacing25,
          ),
          child: Text(
            R.strings.stats,
            style: R.styles.labelStyle,
          ),
        ),
        SizedBox(
          height: R.appRatio.appWidth1 * 15,
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
                          switchBetweenMeterAndKm(data.totalDistance).toString(),
                          R.strings.distanceUnit[DataManager.getUserRunningUnit().index],
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
        )
      ],
    ));
  }

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();

  _buildRunTitle() {
    if (_titleController.text.isEmpty) {
      _titleController.text = widget.activity.title;
    }
    return (Padding(
      padding: EdgeInsets.only(left: R.appRatio.appSpacing15),
      child: InputField(
        controller: _titleController,
        labelTitle: R.strings.title,
      ),
    ));
  }

  _buildDescription() {
    return (Padding(
      padding: EdgeInsets.only(left: R.appRatio.appSpacing15),
      child: InputField(
        controller: _descriptionController,
        labelTitle: R.strings.yourDescription,
        enableMaxLines: true,
      ),
    ));
  }

  Widget buildPhotoPreview(context, index) {
    double deviceWidth = MediaQuery.of(context).size.width;
    File file = this.widget.activity.photos.length >= index + 1
        ? this.widget.activity.photos[index]
        : null;
    return GestureDetector(
      onTap: () {
        this.openSelectPhoto(context, index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: R.colors.blurMajorOrange),
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
    print("Select event with id: $value");
    widget.activity.recordData.eventId = value as int;
  }

  _buildEventDropDown() {
    List<DropDownObject<int>> dropDowMenuList = [];
    dropDowMenuList.add(
        DropDownObject<int>(value: -1, text: R.strings.no));
    EventManager.userEvents.forEach((event) {
      dropDowMenuList.add(
          DropDownObject<int>(value: event.eventId, text: event.eventName));
    });
    return Padding(
        padding: EdgeInsets.only(left: R.appRatio.appSpacing15),
        child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: DropDownMenu(
          errorEmptyData: R.strings.nothingToShow,
          enableFullWidth: true,
          labelTitle: R.strings.events,
          hintText: R.strings.events,
          enableHorizontalLabelTitle: false,
          onChanged: this._getSelectedDropDownMenuItem,
          items: dropDowMenuList,
          initialValue: dropDowMenuList[0].value,
        ),),);
  }

  _buildPhotoPicker() {
    return Padding(
        padding: EdgeInsets.only(left: R.appRatio.appSpacing15),
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(R.strings.yourPhotos, style: R.styles.labelStyle),
              SizedBox(
                height: R.appRatio.appWidth1 * 15,
              ),
              StreamBuilder(
                  stream: this.widget.streamFile.stream,
                  builder: (context, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        buildPhotoPreview(context, 0),
                        buildPhotoPreview(context, 1),
                        buildPhotoPreview(context, 2),
                        buildPhotoPreview(context, 3)
                      ],
                    );
                  })
            ],
          ),
        ));
  }

  _buildMapOptions() {
    return Padding(
      padding: EdgeInsets.only(left: R.appRatio.appSpacing15),
      child: LineButton(
        mainText: R.strings.yourMaps,
        mainTextFontSize: R.appRatio.appFontSize18,
        mainTextStyle: R.styles.labelStyle,
        subText: R.strings.viewMapDescription,
        subTextFontSize: R.appRatio.appFontSize16,
        enableSplashColor: false,
        textPadding: EdgeInsets.all(15),
        enableSwitchButton: true,
        switchButtonOnTitle: "On",
        switchButtonOffTitle: "Off",
        initSwitchStatus: true,
        switchFunction: (state) {
          this.widget.activity.showMap = state;
        },
      ),
    );
  }

  _buildButtons() {
    return Container(
      color: Colors.white,
      width: R.appRatio.deviceWidth,
      height: R.appRatio.deviceHeight * 0.1,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          UIButton(
            color: R.colors.grayABABAB,
            text: R.strings.discard,
            width: R.appRatio.deviceWidth * 0.45,
            height: R.appRatio.appWidth1 * 50,
            onTap: () {
              _clearRecordData();
            },
          ),
          UIButton(
            gradient: R.colors.uiGradient,
            text: R.strings.upload,
            width: R.appRatio.deviceWidth * 0.45,
            height: R.appRatio.appWidth1 * 50,
            onTap: () {
              _uploadActivity();
            },
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
    if (isUploading == true)
      return;
    isUploading = true;
    //this.widget.activity.recordData = await RecordHelper.loadFromFile();
    Response<ActivityData> response = await upload();
    if (response.success) {
      print("Uploaded");
      await RecordHelper.removeFile();
      this.widget.bloc.resetAll();
      showCustomAlertDialog(
        context,
        title: R.strings.notice,
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
      print("Uploaded error");
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
    String requestTime =
        DateTime.now().millisecondsSinceEpoch.toString();
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
    await EventManager.getUserEvents();
  }

  @override
  Widget build(BuildContext context) {
    getEventOfUser();
    var appBar = CustomGradientAppBar(
      titleWidget: Container(
        margin: EdgeInsets.only(right: R.appRatio.appAppBarIconSize),
        child: Center(
          child: Text(R.strings.uploadActivity),
        ),
      ),
      leadingFunction: () {
        this.widget.bloc.updateRecordStatus(RecordState.StatusStop);
        pop(context);
      },
    );

    return WillPopScope(
        onWillPop: () async {
          this.widget.bloc.updateRecordStatus(RecordState.StatusStop);
          return true;
        },
        child: Scaffold(
            resizeToAvoidBottomPadding: true,
            resizeToAvoidBottomInset: true,
            backgroundColor: R.colors.appBackground,
            appBar: appBar,
            body: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Container(
                  height: R.appRatio.deviceHeight * 0.9 -
                      appBar.preferredSize.height -
                      25,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _buildStats(),
                        SizedBox(
                          height: R.appRatio.appSpacing25,
                        ),
                        _buildRunTitle(),
                        SizedBox(
                          height: R.appRatio.appSpacing25,
                        ),
                        _buildDescription(),
                        SizedBox(
                          height: R.appRatio.appSpacing25,
                        ),
                        _buildEventDropDown(),
                        SizedBox(
                          height: R.appRatio.appSpacing25,
                        ),
                        _buildPhotoPicker(),
                        SizedBox(
                          height: R.appRatio.appSpacing25,
                        ),
                        _buildMapOptions(),
                        SizedBox(
                          height: R.appRatio.appSpacing25,
                        ),
                      ],
                    ),
                  ),
                ),
                _buildButtons()
              ],
            ))));
  }
}
