import 'package:flutter/cupertino.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/event_manager.dart';
import 'package:usrun/model/event_details.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';

class EventDetailsPage extends StatefulWidget{
  final int eventId;
  EventDetailsPage({@required this.eventId});

  @override
  State<StatefulWidget> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  EventDetails eventDetails;

  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) => loadEventDetails());
  }

  void loadEventDetails() async {
    Response<dynamic> response = await EventManager.getEventDetails(widget.eventId);
    if(response.success){
      eventDetails = response.object;
    } else {
      showCustomAlertDialog(context,
        title: R.strings.error,
        content: response.errorMessage,
        firstButtonText: R.strings.ok.toUpperCase(),
        firstButtonFunction: () => pop(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}