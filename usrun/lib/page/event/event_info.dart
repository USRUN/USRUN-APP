import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/util/string_utils.dart';
import 'package:usrun/widget/custom_dialog/custom_loading_dialog.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';

class EventInfoPage extends StatefulWidget {
  final Event eventInfo;

  EventInfoPage({
    @required this.eventInfo,
  });

  @override
  _EventInfoPageState createState() => _EventInfoPageState();
}

class _EventInfoPageState extends State<EventInfoPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Event _eventInfo;

  @override
  void initState() {
    super.initState();
    _eventInfo = widget.eventInfo;
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _reloadData() async {
    showCustomLoadingDialog(
      context,
      text: R.strings.loading,
    );

    // TODO: Code here
    Event result = await Future.delayed(Duration(milliseconds: 2500), () {
      print("[EVENT_INFO] Reloading heavy data");
      return Event(

      );
    });

    setState(() {
      _eventInfo = result;
    });

    pop(context);
  }

  Widget _renderBodyContent() {
    // TODO: Code here
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    String appTitle = StringUtils.uppercaseFirstLetterEachWord(
      content: R.strings.eventInformation,
    );

    Widget smartRefresher = SmartRefresher(
      enablePullUp: false,
      controller: _refreshController,
      child: _renderBodyContent(),
      physics: BouncingScrollPhysics(),
      footer: null,
      onRefresh: () => _reloadData(),
      onLoading: () async {
        await Future.delayed(Duration(milliseconds: 200));
      },
    );

    Widget refreshConfigs = RefreshConfiguration(
      child: smartRefresher,
      headerBuilder: () => WaterDropMaterialHeader(
        backgroundColor: R.colors.majorOrange,
      ),
      footerBuilder: null,
      shouldFooterFollowWhenNotFull: (state) {
        return false;
      },
      hideFooterWhenNotFull: true,
    );

    Widget buildElement = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(title: appTitle),
      body: refreshConfigs,
    );

    return NotificationListener<OverscrollIndicatorNotification>(
      child: buildElement,
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return false;
      },
    );
  }
}
