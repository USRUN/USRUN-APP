import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/widget/drop_down_menu/drop_down_menu.dart';
import 'package:usrun/widget/drop_down_menu/drop_down_object.dart';
import 'package:usrun/widget/input_field.dart';
import 'package:usrun/widget/input_calendar.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/util/image_cache_manager.dart';

class EditProfilePage extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _biographyController = TextEditingController();
  final String _userCode = "STU1653072";
  final _dropDownMenuItemList = [
    DropDownObject<int>(value: 0, text: 'Male'),
    DropDownObject<int>(value: 1, text: 'Female'),
    DropDownObject<int>(value: 2, text: 'Prefer not to say'),
    DropDownObject<int>(value: 3, text: 'Other'),
  ];

  void _getDOBFunction(DateTime picker) {
    print("Birthday/DOB: ${picker.day}/${picker.month}/${picker.year}");

    // TODO: Do something with "picker" variable
  }

  void _getSelectedDropDownMenuItem<T>(T value) {
    print("Selected item with value: $value");

    // TODO: Do something with "object" variable
  }

  void _updateProfile(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());

    // TODO: Function for updating changes of profile
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: R.colors.appBackground,
      appBar: GradientAppBar(
        leading: FlatButton(
          onPressed: () => pop(context),
          padding: EdgeInsets.all(0.0),
          splashColor: R.colors.lightBlurMajorOrange,
          textColor: Colors.white,
          child: ImageCacheManager.getImage(
            url: R.myIcons.appBarBackBtn,
            width: R.appRatio.appAppBarIconSize,
            height: R.appRatio.appAppBarIconSize,
          ),
        ),
        gradient: R.colors.uiGradient,
        centerTitle: true,
        title: Text(
          R.strings.editProfile,
          style: TextStyle(
              color: Colors.white, fontSize: R.appRatio.appFontSize22),
        ),
        actions: <Widget>[
          Container(
            width: R.appRatio.appWidth60,
            child: FlatButton(
              onPressed: () => _updateProfile(context),
              padding: EdgeInsets.all(0.0),
              splashColor: R.colors.lightBlurMajorOrange,
              textColor: Colors.white,
              child: ImageCacheManager.getImage(
                url: R.myIcons.appBarCheckBtn,
                width: R.appRatio.appAppBarIconSize,
                height: R.appRatio.appAppBarIconSize,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing15,
            right: R.appRatio.appSpacing15,
          ),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                Align(
                  alignment: Alignment.center,
                  child: AvatarView(
                    avatarImageURL: R.images.avatarQuocTK,
                    avatarImageSize: R.appRatio.appAvatarSize150,
                    enableSquareAvatarImage: false,
                    pressAvatarImage: () {
                      // TODO: A function for doing something
                      // Example: Click to change avatar of my profile or my teams, or direct to other pages.
                      print(R.strings.nothingToShow);
                    },
                    avatarBoxBorder: Border.all(
                      color: R.colors.majorOrange,
                      width: 2,
                    ),
                    supportImageURL: R.images.avatar,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                Text(
                  "TRẦN KIẾN QUỐC",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: R.appRatio.appFontSize18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing5,
                ),
                Text(
                  _userCode,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: R.colors.contentText,
                      fontSize: R.appRatio.appFontSize18),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: R.appRatio.appWidth181,
                      child: InputField(
                        controller: _firstNameController,
                        enableFullWidth: false,
                        labelTitle: R.strings.firstName,
                        hintText: R.strings.firstName,
                      ),
                    ),
                    Container(
                      width: R.appRatio.appWidth181,
                      child: InputField(
                        controller: _lastNameController,
                        enableFullWidth: false,
                        labelTitle: R.strings.lastName,
                        hintText: R.strings.lastName,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                InputField(
                  controller: _emailController,
                  enableFullWidth: true,
                  labelTitle: R.strings.email,
                  hintText: R.strings.emailHint,
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: R.appRatio.appWidth181,
                      child: InputField(
                        controller: _countryController,
                        enableFullWidth: false,
                        labelTitle: R.strings.country,
                        hintText: R.strings.country,
                      ),
                    ),
                    Container(
                      width: R.appRatio.appWidth181,
                      child: InputField(
                        controller: _cityController,
                        enableFullWidth: false,
                        labelTitle: R.strings.city,
                        hintText: R.strings.city,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: R.appRatio.appWidth181,
                      child: InputField(
                        controller: _districtController,
                        enableFullWidth: false,
                        labelTitle: R.strings.district,
                        hintText: R.strings.district,
                      ),
                    ),
                    Container(
                      width: R.appRatio.appWidth181,
                      child: InputField(
                        controller: _jobController,
                        enableFullWidth: false,
                        labelTitle: R.strings.whatYourJob,
                        hintText: R.strings.whatYourJobHint,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: R.appRatio.appWidth181,
                      child: InputCalendar(
                        labelTitle: R.strings.birthday,
                        enableFullWidth: false,
                        getDOBFunc: this._getDOBFunction,
                      ),
                    ),
                    DropDownMenu(
                      errorEmptyData: R.strings.nothingToShow,
                      enableFullWidth: false,
                      labelTitle: R.strings.gender,
                      hintText: R.strings.gender,
                      enableHorizontalLabelTitle: false,
                      onChanged: this._getSelectedDropDownMenuItem,
                      items: this._dropDownMenuItemList,
                      initialValue: _dropDownMenuItemList[0].value,
                    ),
                  ],
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: R.appRatio.appWidth181,
                      child: InputField(
                        controller: _heightController,
                        enableFullWidth: false,
                        labelTitle: R.strings.height,
                        hintText: "170",
                        suffixText: "cm",
                        textInputType: TextInputType.number,
                      ),
                    ),
                    Container(
                      width: R.appRatio.appWidth181,
                      child: InputField(
                        controller: _weightController,
                        enableFullWidth: false,
                        labelTitle: R.strings.weight,
                        hintText: "50",
                        suffixText: "kg",
                        textInputType: TextInputType.number,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                InputField(
                  controller: _biographyController,
                  enableFullWidth: true,
                  labelTitle: R.strings.biography,
                  hintText: R.strings.biographyHint,
                  enableMaxLines: true,
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
        child: _buildElement,
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        });
  }
}
