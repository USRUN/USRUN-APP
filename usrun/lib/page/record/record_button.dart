import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/page/record/bloc_provider.dart';
import 'package:usrun/page/record/record_bloc.dart';
import 'package:usrun/page/record/record_const.dart';
import 'package:usrun/page/record/record_components.dart';

class RecordButton extends StatelessWidget{
  RecordBloc bloc;

  BuildContext context;

  bool isStartProcessing = false;

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

  _buildLayoutForStatePause(BuildContext context, Size screenSize) {
    return Align(alignment: Alignment.bottomCenter,
      child: Row(
      children: <Widget>[
        Container( 
          width: screenSize.width,
          alignment: Alignment.bottomCenter,
          child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          StateButton(disabled: false, icon: R.icon.icResumeRecord, icSize: 50, size: windowWidth/5, onPress: (){}),
          SizedBox(width: 10,),
          StateButton(disabled: false, icon: R.icon.icStopRecord, icSize: 50, size: windowWidth/5, onPress: (){})
        ],),
        ),
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
              return Align(alignment: Alignment.bottomCenter,
              child: StateButton(disabled: false, icon: R.icon.icStartRecord, icSize: 50, size: windowWidth/5, onPress: ()=> onStartButtonTap()));
            break;
             case RecordState.StatusStart:
              return Align(alignment: Alignment.bottomCenter,
              child: StateButton(disabled: false, icon: R.icon.icPauseRecord, icSize: 50, size: windowWidth/5, onPress: ()=> onPauseButtonTap()));
            break;   
            //   return this._buildLayoutForStateStart(context, sizeScreen);
             case RecordState.StatusStop:
              return _buildLayoutForStatePause(context, sizeScreen);
            //   return this._buildLayoutForStateStop(sizeScreen, context);
            // case RecordState.StatusResume:
            // return this._buildLayoutForStateResume(sizeScreen);
            // case RecordState.StatusFinish:
            //   return this._buildLayoutForStateFinish();
            // default:
            //   return this._buildLayoutForStateNone(context);
          }
        }
    ));
  }

}