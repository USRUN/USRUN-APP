import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/page/record/activity_data.dart';
import 'package:usrun/page/record/record_bloc.dart';
import 'package:usrun/page/record/record_data.dart';
import 'package:usrun/widget/input_field.dart';
import 'package:usrun/widget/line_button.dart';
import 'package:usrun/widget/my_info_box/normal_info_box.dart';
import 'package:usrun/widget/ui_button.dart';

import 'bloc_provider.dart';


class RecordUploadPage extends StatefulWidget {


  RecordBloc bloc;
  ActivityData activity;
  
  MyStreamController<File> streamFile;

  RecordUploadPage(RecordBloc recordBloc) {
    bloc = recordBloc;
    activity = new ActivityData(123);
    streamFile = MyStreamController(defaultValue: null, activeBroadcast: true);
  }

  @override
  _RecordUploadPage createState() => _RecordUploadPage();
}


class _RecordUploadPage extends State<RecordUploadPage>{

  _buildStatsBox(String title, String value, String unit){
    return NormalInfoBox( 
      boxSize: 120,
      id: title,
      firstTitleLine: title,
      secondTitleLine: unit,
      dataLine: value,
      disableGradientLine: true,
      boxRadius: 0,
      disableBoxShadow: true,
    );
  }

  _buildStats(){
    RecordData data = widget.bloc.recordData;
    return (
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: R.appRatio.appWidth1*25,
            left: R.appRatio.appSpacing25,
          ),
          child: Text(
            R.strings.stats,
            style: R.styles.labelStyle,
          ),
        ),
        SizedBox(height: R.appRatio.appWidth1*15,),
        Center(
          child: Container( 
          height: R.appRatio.appWidth1*242,
          width: R.appRatio.appWidth1*363,
          child: Stack(children: <Widget>[
            Center(child: Container( 
            height: R.appRatio.appWidth1*240,
            width: R.appRatio.appWidth1*360,
            color: R.colors.majorOrange,),),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildStatsBox(R.strings.distance, data.totalDistance.toString(), R.strings.distanceUnit),
                  _buildStatsBox(R.strings.time, (Duration(seconds: data.totalTime).toString()).substring(0,7), R.strings.timeUnit), 
                  _buildStatsBox(R.strings.avgPace, data.avgPace.toString(), R.strings.avgPaceUnit)
              ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildStatsBox(R.strings.avgHeart, data.avgHeart==-1?"N/A":data.avgHeart.toString(), R.strings.avgHeartUnit),
                  _buildStatsBox(R.strings.calories, data.calories==-1?"N/A":data.calories.toString(), R.strings.caloriesUnit), 
                  _buildStatsBox(R.strings.total, data.totalStep==-1?"N/A":data.totalStep.toString(), R.strings.totalUnit)
              ],)
            ],)
          ],),
        ),)
      ],)
    );
  }

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();

  _buildRunTitle(){
    _titleController.text = widget.activity.title;
    return(
      Padding( 
        padding: EdgeInsets.only(left: R.appRatio.appSpacing15),
        child: InputField( 
          controller: _titleController,
          labelTitle: R.strings.title,
        ),
      )
    );
  }

  _buildDescription(){
    return(
      Padding( 
        padding: EdgeInsets.only(left: R.appRatio.appSpacing15),
        child: InputField( 
          controller: _descriptionController,
          labelTitle: R.strings.description,
          enableMaxLines: true,
        ),
      )
    );
  }

  Widget buildPhotoPreview(context, index) {
      File file = this.widget.activity.photos.length >= index + 1
          ?  this.widget.activity.photos[index]
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
          height: R.appRatio.appWidth1*80,
          width: R.appRatio.appWidth1*80,
          child: file != null ? Image.file(file, height: R.appRatio.appWidth1*80,
              width: R.appRatio.appWidth1*80,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low) : Icon(
            Icons.add,
            size: R.appRatio.appWidth1*40,
            color: R.colors.majorOrange,
          ),
        ),
      );
  }

  Future<void> openSelectPhoto(BuildContext context, int indexPhoto) async{
    try {
      var image = await pickImage(context);
      if (image != null) {
        widget.activity.addPhotoFile(image, indexPhoto);
        this.widget.streamFile.add(image);
      }
    } catch (error) {
      print(error);
    }
  }

  _buildPhotoPicker(){
  return Padding( 
      padding: EdgeInsets.only(left: R.appRatio.appSpacing15),
      child: Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(R.strings.photos, style: R.styles.labelStyle),
          SizedBox(height: R.appRatio.appWidth1*15,),
          StreamBuilder(
            stream: this.widget.streamFile.stream,
            builder: (context, snapshot) {
              return Row(
                children: <Widget>[
                  buildPhotoPreview(context,0),
                  SizedBox(width: 10),
                  buildPhotoPreview(context,1),
                  SizedBox(width: 10),
                  buildPhotoPreview(context,2),
                  SizedBox(width: 10),
                  buildPhotoPreview(context,3)
                ],
              );
            }
          )
        ],
      ),
    ));
  }

  _buildMapOptions(){
    return(
      Padding( 
        padding: EdgeInsets.only(left: R.appRatio.appSpacing15),
        child: LineButton(
            mainText: R.strings.maps,
            mainTextFontSize: R.appRatio.appFontSize18,
            mainTextStyle: R.styles.labelStyle,
            subText: R.strings.viewMapDescription,
            subTextFontSize: R.appRatio.appFontSize14,
            spacingUnderlineAndMainText: R.appRatio.appSpacing15,
            enableSwitchButton: true,
            switchButtonOnTitle: "On",
            switchButtonOffTitle: "Off",
            initSwitchStatus: true,
            switchFunction: (state) {
              this.widget.activity.showMap = state;
            },
          ),
      )
    );
  }

  _buildButtons(){
    return Container( 
        color: Colors.white,
        width: R.appRatio.deviceWidth,
        height: R.appRatio.deviceHeight*0.1,
        alignment: Alignment.center,
        child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
            UIButton( 
              color: R.colors.grayABABAB,
              text: "Discard",
              width: R.appRatio.deviceWidth*0.45,
              height: R.appRatio.appWidth1*50,
              onTap: (){},
            ),
            UIButton( 
              gradient: R.colors.uiGradient,
              text: "Upload",
              width: R.appRatio.deviceWidth*0.45,
              height: R.appRatio.appWidth1*50,
              onTap: (){},
            ),
          ],),
      
    );
  }





  @override 
  Widget build(BuildContext context){
    var appBar =  GradientAppBar(
        leading: new IconButton(
          icon: Image.asset(
            R.myIcons.appBarBackBtn,
            width: R.appRatio.appAppBarIconSize,
          ),
          onPressed: () => pop(context),
        ),
        title: Container(
          margin: EdgeInsets.only(right: R.appRatio.appAppBarIconSize),
          child:  Center(child: Text(R.strings.uploadActivity),),
        ),
        gradient: R.colors.uiGradient,
      );
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: R.colors.appBackground,
      appBar: appBar,
      body: Column(children: <Widget>[
      Container( 
        height: R.appRatio.deviceHeight*0.9 - appBar.preferredSize.height - 25,
        child: SingleChildScrollView(
        child: Column(children: <Widget>[
          _buildStats(),
          SizedBox(height: R.appRatio.appSpacing25,),
          _buildRunTitle(),
          SizedBox(height: R.appRatio.appSpacing25,),
          _buildDescription(),
          SizedBox(height: R.appRatio.appSpacing25,),
          _buildPhotoPicker(),
          SizedBox(height: R.appRatio.appSpacing25,),
          _buildMapOptions(),
          SizedBox(height: R.appRatio.appSpacing25,),
        ],),
      ),
      ),
      _buildButtons()
      ],));
  }
}