import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/model/splits.dart';
import 'package:usrun/model/user_activity.dart';
import 'package:usrun/widget/feed/compact_user_activity_item.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<UserActivity> _userActivityList;
  int _page;
  bool _allowLoadMore;

  @override
  void initState() {
    super.initState();
    _getNecessaryData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!_allowLoadMore) return;

    // TODO: Demo data --> Call API here & use "_page"
    List<UserActivity> result = [
      UserActivity(
        userId: 2,
        userDisplayName: "2 Kiến Quốc Trần",
        userAvatar: R.images.avatarQuocTK,
        userHcmus: true,
        userActivityId: 2,
        title: "Morning running!",
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        createTime: DateTime.now(),
        showMap: true,
        photos: [
          'https://m.media-amazon.com/images/M/MV5BOTk5ODg0OTU5M15BMl5BanBnXkFtZTgwMDQ3MDY3NjM@._V1_QL50_SY1000_CR0,0,674,1000_AL_.jpg',
          'https://i1091.photobucket.com/albums/i395/ugg-boot/kid%20ugg%20boot/ugg-5991-kids-sand-boots_05.jpg',
          'https://i1088.photobucket.com/albums/i324/chishono/Short%20North%20Chiropractic/shortnorthchiropractic10.jpg',
          'https://i1217.photobucket.com/albums/dd388/jnelson9r/J%20Nelson%20Real%20Estate/JNELSONREALESTATE2.jpg',
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedFCAwayFlamesWallpaperbySunnyboiiii.jpg',
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg',
        ],
        eventId: 2,
        eventName: "UpRace - Move Viet Nam",
        eventThumbnail: R.images.drawerBackgroundDarker,
        totalDistance: 42500,
        totalTime: 45943,
        avgPace: 705,
        totalStep: 34851,
        avgHeart: 145.5,
        maxHeart: 165.8,
        calories: 185,
        elevGain: 160,
        elevMax: 50,
        splitModelArray: [
          SplitModel(pace: 352, km: 1),
          SplitModel(pace: 287, km: 2),
          SplitModel(pace: 478, km: 3),
          SplitModel(pace: 361, km: 0.43),
        ],
      ),
      UserActivity(
        userId: 1,
        userDisplayName: "1 Kiến Quốc Trần",
        userAvatar: R.images.avatarQuocTK,
        userHcmus: true,
        userActivityId: 1,
        title:
            "Morning running! Morning running! Morning running! Morning running! Morning running!",
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        createTime: DateTime.now(),
        showMap: false,
        photos: [
          'https://m.media-amazon.com/images/M/MV5BOTk5ODg0OTU5M15BMl5BanBnXkFtZTgwMDQ3MDY3NjM@._V1_QL50_SY1000_CR0,0,674,1000_AL_.jpg',
          'https://i1091.photobucket.com/albums/i395/ugg-boot/kid%20ugg%20boot/ugg-5991-kids-sand-boots_05.jpg',
          'https://i1088.photobucket.com/albums/i324/chishono/Short%20North%20Chiropractic/shortnorthchiropractic10.jpg',
          'https://i1217.photobucket.com/albums/dd388/jnelson9r/J%20Nelson%20Real%20Estate/JNELSONREALESTATE2.jpg',
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedFCAwayFlamesWallpaperbySunnyboiiii.jpg',
          "https://i1078.photobucket.com/albums/w481/sunnyboiiii/Manchester%20United/ManchesterUnitedRedLogoWallpaperbyDALIBOR.jpg",
          'https://i1078.photobucket.com/albums/w481/sunnyboiiii/Western%20Sydney%20Wanderers%20FC/WSWFCFlamesShortQuoteWallpaperbySunnyboiiii.jpg',
        ],
        totalDistance: 42500,
        totalTime: 45943,
        avgPace: 705,
        totalStep: 34851,
        avgHeart: 145.5,
        maxHeart: 165.8,
        calories: 185,
        elevGain: 160,
        elevMax: 50,
        splitModelArray: [
          SplitModel(pace: 571, km: 1),
          SplitModel(pace: 472, km: 2),
          SplitModel(pace: 749, km: 3),
          SplitModel(pace: 397, km: 4),
          SplitModel(pace: 397, km: 5),
          SplitModel(pace: 623, km: 6),
        ],
      ),
    ];

    if (result != null && result.length != 0) {
      setState(() {
        _userActivityList.insertAll(_userActivityList.length, result);
        _page += 1;
      });
    } else {
      setState(() {
        _allowLoadMore = false;
      });
    }
  }

  Future<void> _getNecessaryData() async {
    setState(() {
      _userActivityList = List();
      _page = 0;
      _allowLoadMore = true;
    });
    await _loadData();
    _refreshController.refreshCompleted();
  }

  Widget _renderBodyContent() {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(0.0),
      itemCount: _userActivityList.length,
      itemBuilder: (context, index) {
        // TODO: Please open it after getting data from API in function above
//        if (index == _userActivityList.length - 1) {
//          _loadData();
//        }

        return Container(
          margin: EdgeInsets.only(
              bottom: (index != _userActivityList.length - 1 ? 12.0 : 0)),
          child: CompactUserActivityItem(
            userActivity: _userActivityList[index],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget smartRefresher = SmartRefresher(
      enablePullUp: false,
      controller: _refreshController,
      child: _renderBodyContent(),
      physics: BouncingScrollPhysics(),
      footer: null,
      onRefresh: () => _getNecessaryData(),
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

    return NotificationListener<OverscrollIndicatorNotification>(
      child: refreshConfigs,
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return false;
      },
    );
  }
}
