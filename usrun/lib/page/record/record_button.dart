import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/page/record/bloc_provider.dart';
import 'package:usrun/page/record/record_bloc.dart';
import 'package:usrun/page/record/record_const.dart';
import 'package:usrun/page/record/record_components.dart';
import 'package:usrun/page/record/record_upload_page.dart';

class RecordButton extends StatelessWidget{
  RecordBloc bloc;

  BuildContext context;

  bool isStartProcessing = false;

void showNoGPS(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("GPS not found"),
            content: Text("GPS not detected. Please activate it."),
          )
      );
    }

  void onStartButtonTap(){
    try{
      this.bloc.hideGPSView();
      print(this.bloc.currentRecordState);
      this.bloc.updateRecordStatus(RecordState.StatusStart);
    }
    catch(error){}
  }

  void onPauseButtonTap(){
    this.bloc.updateRecordStatus(RecordState.StatusStop);
  }

  void onFinishButtonTap(context){
    this.bloc.updateRecordStatus(RecordState.StatusFinish);
    pushPage(context, RecordUploadPage(this.bloc));
  }

  void onResumeButtonTap(){
    this.bloc.updateRecordStatus(RecordState.StatusResume);
  }
  

  _buildLayoutForStatePause(BuildContext context) {
    return Row(
      children: <Widget>[
        Container( 
          width: R.appRatio.deviceWidth,
          alignment: Alignment.bottomCenter,
          child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          StateButton(disabled: false, icon: R.myIcons.icResumeRecord, size: R.appRatio.deviceWidth/5, onPress: () {onResumeButtonTap();} ),
          SizedBox(width: R.appRatio.appSpacing15,),
          StateButton(disabled: false, icon: R.myIcons.icStopRecord, size: R.appRatio.deviceWidth/5, onPress: () {onFinishButtonTap(context);} ),
          SizedBox(width: R.appRatio.appSpacing15,),
          Container(
            alignment: Alignment.centerLeft,
            width: R.appRatio.deviceWidth/5,
            height: R.appRatio.deviceWidth/5,
            child: Stack(children: <Widget>[_buildStatisticButton()]),
          )                   
        ],),
        ),
      ],
    );  
    
  }

 _buildLayoutForStateStart(BuildContext context) {
    return Row(
      children: <Widget>[
        Container( 
          width: R.appRatio.deviceWidth,
          alignment: Alignment.bottomCenter,
          child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          SizedBox(width: R.appRatio.deviceWidth/5+ R.appRatio.appSpacing15,),
          StateButton(disabled: false, icon: R.myIcons.icPauseRecord, size: R.appRatio.deviceWidth/5, onPress: () {onPauseButtonTap();} ),
          SizedBox(width: R.appRatio.appSpacing15,),
          Container(
            alignment: Alignment.centerLeft,
            width: R.appRatio.deviceWidth/5,
            height: R.appRatio.deviceWidth/5,
            child: Stack(children: <Widget>[_buildStatisticButton()]),
          )                   
        ],),
        ),
      ],
    );   
  }

  _buildStatisticButton(){
    return StreamBuilder<ReportVisibility>(
        stream: this.bloc.streamReportVisibility,
        initialData: ReportVisibility.Gone,
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.data == ReportVisibility.Gone)
            return StateButton(disabled: false, icon: R.myIcons.icStatisticWhite, size: R.appRatio.deviceWidth/7, 
              onPress: () => this.bloc.updateReportVisibility(ReportVisibility.Visible),
            );
          else{
            return StateButton(disabled: false, icon: R.myIcons.icStatisticColor, size: R.appRatio.deviceWidth/7, 
              onPress: () => this.bloc.updateReportVisibility(ReportVisibility.Gone),
            );
          }
        });
  }


  _buildLayoutForStateNone(BuildContext context) {
    return Align(alignment: Alignment.bottomCenter,
      child: Row(
      children: <Widget>[
        StreamBuilder<Object>(
                  stream: this.bloc.streamGPSStatus,
                  builder: (context, snapshot) {
        return Container( 
          width: R.appRatio.deviceWidth,
          alignment: Alignment.bottomCenter,
          child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          SizedBox(width: R.appRatio.deviceWidth/5+ R.appRatio.appSpacing15,),
          StateButton(
            disabled: false, 
            icon: R.myIcons.icStartRecord, 
            size: R.appRatio.deviceWidth/5, 
            onPress: snapshot.data == null || snapshot.data != GPSSignalStatus.READY? 
            (){showNoGPS(context);} : () {onStartButtonTap();} ),
          SizedBox(width: R.appRatio.appSpacing15,),
         
          Container(
            alignment: Alignment.centerLeft,
            width: R.appRatio.deviceWidth/5,
            height: R.appRatio.deviceWidth/5,
            child: Stack(children: <Widget>[ChooseEventButton((){})]),
          )                   
        ],),
        );
       })
      ],
    )
    );   
  }
  
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of(context);
    Size sizeScreen = MediaQuery.of(context).size;
    this.context = context;
    return Container (
      padding: EdgeInsets.only(top: 10, bottom: sizeScreen.height/75.0),
      child: StreamBuilder(
        initialData: RecordState.StatusNone,
        stream: bloc.streamRecordState,
        builder: (BuildContext context, snapShot) {
          var state = snapShot.data;
          switch(state) {
            case RecordState.StatusNone:
              return _buildLayoutForStateNone(context);
            break;
             case RecordState.StatusStart:
              return _buildLayoutForStateStart(context);
            break;   
             case RecordState.StatusStop:
              return _buildLayoutForStatePause(context);
            break;
             case RecordState.StatusResume:
             return _buildLayoutForStateStart(context);
            break;
             case RecordState.StatusFinish:
              return _buildLayoutForStateNone(context);
            break;
             default:
              return _buildLayoutForStateNone(context);
          }
        }
    ));
  }

}

class ChooseEventButton extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ChooseEventButtonState();
  final Function onPress;
  ChooseEventButton(this.onPress);
}

class _ChooseEventButtonState extends State<ChooseEventButton> {
  var isPressed = false;
  var icon = R.myIcons.icRecordEventWhite;

  @override
  Widget build(BuildContext context) {
    return StateButton(disabled: false, icon: icon, size: R.appRatio.deviceWidth/7, 
      onPress: (){
        setState(() {
          if (isPressed)
            icon = R.myIcons.icRecordEventWhite;
          else
            icon = R.myIcons.icRecordEventColor;
            isPressed=!isPressed;
        });
        widget.onPress();
      });
  }
}