import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/widget/my_info_box/complex_info_box.dart';
import 'package:usrun/widget/loading_dot.dart';

// Demo data
import 'package:usrun/demo_data.dart';

class ProfileStatsDay extends StatefulWidget {
  final DateTime day;

  ProfileStatsDay({
    @required this.day,
  });

  @override
  _ProfileStatsDayState createState() => _ProfileStatsDayState();
}

class _ProfileStatsDayState extends State<ProfileStatsDay> {
  bool _isLoading;
  List _items;

  /*
    + Structure of the "items" variable: 
    [
      {
        "id": "0",                         [This field is compulsory]
        "title": "Average Pace",
        "data": "8:71",
        "unit": "/km",
        "iconURL": <string>,
        "iconSize": 20,                    [Optional]
        "enableCircleStyle": true,         [Choose "enableCircleStyle", or "enableImageStyle", or not choose anything]
        "circleSize": 80,                  [Optional]
        "enableImageStyle": true,          [Optional]
        "imageURL": <string>,              [If "enableImageStyle" is true, please do not forget this field]
      },
      ...
    ]
  */

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _items = DemoData().statsListStyle02;
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateLoading());
  }

  void _updateLoading() {
    Future.delayed(Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _isLoading = !_isLoading;
      });
    });
  }

  void _pressBox(boxID) {
    // TODO: Implement function here
    print("[ComplexBoxWidget] This box with id $boxID is pressed");
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading
        ? LoadingDotStyle02()
        : (this._isEmptyList()
            ? this._buildEmptyList() // Empty item list
            : this._buildList() // Render item list
        ));
  }

  bool _isEmptyList() {
    return ((_items == null || _items.length == 0) ? true : false);
  }

  Widget _buildEmptyList() {
    String systemNoti = "Nothing to show";

    return Center(
      child: Text(
        systemNoti,
        style: TextStyle(
          fontSize: R.appRatio.appFontSize18,
          color: R.colors.normalNoteText,
        ),
      ),
    );
  }

  Widget _renderItem(int itemPos, dynamic item) {
    return Container(
      padding: EdgeInsets.only(
        bottom: R.appRatio.appSpacing15,
      ),
      child: ComplexInfoBox(
        id: (item.containsKey('id') ? item['id'] : itemPos.toString()),
        boxTitle: (item.containsKey('title') ? item['title'] : "N/A"),
        dataTitle: (item.containsKey('data') ? item['data'] : "N/A"),
        unitTitle: (item.containsKey('unit') ? item['unit'] : "N/A"),
        boxIconURL: (item.containsKey('iconURL') ? item['iconURL'] : null),
        boxIconSize: (item.containsKey('iconSize')
            ? item['iconSize']
            : R.appRatio.appIconSize20),
        enableCircleStyle: (item.containsKey('enableCircleStyle')
            ? item['enableCircleStyle']
            : false),
        circleSize: (item.containsKey('circleSize')
            ? item['circleSize']
            : R.appRatio.appWidth80),
        enableImageStyle: (item.containsKey('enableImageStyle')
            ? item['enableImageStyle']
            : false),
        imageURL: (item.containsKey('imageURL') ? item['imageURL'] : null),
        pressBox: _pressBox,
      ),
    );
  }

  List<Widget> _renderAllItem(int start, int end) {
    List<Widget> element = [];
    for (int i = start; i < end; ++i) {
      element.add(_renderItem(i, _items[i]));
    }
    return element;
  }

  Widget _buildList() {
    // Compute some data
    int _seperatedPoint = (_items.length / 2).round();
    List<Widget> _firstColumn = _renderAllItem(0, _seperatedPoint);
    List<Widget> _secondColumn = _renderAllItem(_seperatedPoint, _items.length);

    // Render result
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: _firstColumn,
          ),
          SizedBox(
            width: R.appRatio.appSpacing15,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: _secondColumn,
          ),
        ],
      ),
    );
  }
}
