import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/event_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/widget/custom_dialog/custom_alert_dialog.dart';

class EventDescriptionPage extends StatefulWidget {
  final Event event;

  EventDescriptionPage({this.event});

  @override
  State<StatefulWidget> createState() => _EventDescriptionState();
}

class _EventDescriptionState extends State<EventDescriptionPage> {
  bool _isLoading;
  Event event;
  int eventId;
  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _updateLoading();
    eventId = event.eventId;
    _refreshController = RefreshController(initialRefresh: false);

    if (widget.event != null) {
      event = widget.event;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadEvent());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateLoading());
  }

  void _updateLoading() {
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = !_isLoading;
      });
    });
  }

  _reloadData() async {
    _isLoading = true;

    _loadEvent();
    _updateLoading();
    _refreshController.refreshCompleted();
  }

  _loadEvent() async {
    Response<dynamic> response = await EventManager.getEventInfo(eventId,UserManager.currentUser.userId);
    if (response.success && response.object != null) {
      event = response.object;
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
