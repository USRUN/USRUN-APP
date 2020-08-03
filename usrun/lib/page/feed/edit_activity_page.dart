import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/model/user_activity.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/util/string_utils.dart';
import 'package:usrun/widget/custom_dialog/custom_loading_dialog.dart';
import 'package:usrun/widget/custom_gradient_app_bar.dart';
import 'package:usrun/widget/input_field.dart';

class EditActivityPage extends StatefulWidget {
  final UserActivity userActivity;

  EditActivityPage({
    @required this.userActivity,
  });

  @override
  _EditActivityPageState createState() => _EditActivityPageState();
}

class _EditActivityPageState extends State<EditActivityPage> {
  final double _spacing = 15.0;
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  final FocusNode _titleNode = FocusNode();
  final FocusNode _descriptionNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleTextController.text = widget.userActivity.title;
    _descriptionTextController.text = widget.userActivity.description;
  }

  void _unFocusAllTextFields() {
    _titleNode.unfocus();
    _descriptionNode.unfocus();
  }

  Future<void> _doTapBack() {
    // TODO: Code here
    print("Do tap back");

    pop(context);
    return false;
  }

  Future<void> _updateActivityData() async {
    showCustomLoadingDialog(context);

    // TODO: Code here
    print("Updating activity information");

    pop(context);
  }

  Widget _renderUpdatingButton() {
    return Container(
      width: 55,
      child: FlatButton(
        padding: EdgeInsets.all(0.0),
        splashColor: R.colors.lightBlurMajorOrange,
        textColor: Colors.white,
        onPressed: _updateActivityData,
        child: ImageCacheManager.getImage(
          url: R.myIcons.appBarCheckBtn,
          width: 18,
          height: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _renderTitleBox() {
    return Container(
      margin: EdgeInsets.only(
        left: _spacing,
        right: _spacing,
      ),
      padding: EdgeInsets.only(
        top: _spacing,
      ),
      child: InputField(
        controller: _titleTextController,
        focusNode: _titleNode,
        labelTitle: R.strings.title,
        enableLabelShadow: true,
        enableFullWidth: true,
      ),
    );
  }

  Widget _renderDescriptionBox() {
    return Container(
      margin: EdgeInsets.only(
        top: _spacing * 1.5,
        left: _spacing,
        right: _spacing,
      ),
      child: InputField(
        controller: _descriptionTextController,
        focusNode: _descriptionNode,
        labelTitle: R.strings.description,
        enableLabelShadow: true,
        enableFullWidth: true,
        enableMaxLines: true,
        textInputType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
      ),
    );
  }

  Widget _renderPhotos() {
    // TODO: Code here
    return Container();
  }

  Widget _renderMap() {
    // TODO: Code here
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle = uppercaseFirstLetterEachWord(
      content: R.strings.editActivity,
      pattern: " ",
    );

    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: R.colors.appBackground,
      appBar: CustomGradientAppBar(
        title: appBarTitle,
        leadingFunction: _doTapBack,
        actions: <Widget>[
          _renderUpdatingButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Title
            _renderTitleBox(),
            // Description
            _renderDescriptionBox(),
            // Photos
            _renderPhotos(),
            // Use your map or default map
            _renderMap(),
            SizedBox(height: _spacing),
          ],
        ),
      ),
    );

    _buildElement = WillPopScope(
      child: _buildElement,
      onWillPop: _doTapBack,
    );

    return NotificationListener<OverscrollIndicatorNotification>(
      child: _buildElement,
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return false;
      },
    );
  }
}
