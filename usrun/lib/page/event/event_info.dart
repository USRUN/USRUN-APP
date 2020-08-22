import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/event_manager.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/event_athlete.dart';
import 'package:usrun/model/event_info.dart';
import 'package:usrun/model/event_team.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/page/event/event_athletes.dart';
import 'package:usrun/page/event/event_leaderboard.dart';
import 'package:usrun/page/event/event_teams.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/line_button.dart';

class EventInfoPage extends StatefulWidget {
  final int eventId;

  EventInfoPage({@required this.eventId});

  @override
  _EventInfoPageState createState() => _EventInfoPageState();
}

class _EventInfoPageState extends State<EventInfoPage> {

  EventInfo info;

  @override
  void initState() {
    super.initState();

    _loadInfo();
  }

  _loadInfo() async {
    Response<dynamic> response = await EventManager.getEventInfo(widget.eventId, UserManager.currentUser.userId);
    if(response.success && response.object != null){
      info = response.object;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomGradientAppBar(title: "Event Info",),
        LineButton(
          mainText: "Leaderboard",
          lineFunction: () {
            pushPage(context, EventLeaderboardPage(eventId: widget.eventId, teamId: info.teamId,));
          },
        ),
        LineButton(
          mainText: "Event team",
          lineFunction: () {
            pushPage(context, EventTeamSearchPage(eventId: widget.eventId));
          },
        ),
        LineButton(
          mainText: "Event athletes",
          lineFunction: () {
            pushPage(context, EventAthleteSearchPage(eventId: widget.eventId));
          },
        )
      ],
    );
  }
}
